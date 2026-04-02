import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_image_widget.dart';
import '../../data/models/certificate_model.dart';
import '../../data/repositories/certificate_repository.dart';
import 'pdf_viewer_screen.dart';

// ── File type helpers ─────────────────────────────────────────────────────────
bool _isPdf(String? url) {
  if (url == null) return false;
  return url.toLowerCase().split('?').first.endsWith('.pdf');
}

bool _isImage(String? url) {
  if (url == null) return false;
  final ext = url.toLowerCase().split('?').first.split('.').last;
  return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
}

IconData _fileIcon(String? url) {
  if (_isPdf(url)) return Icons.picture_as_pdf_rounded;
  if (_isImage(url)) return Icons.image_rounded;
  return Icons.insert_drive_file_rounded;
}

String _fileLabel(String? url) {
  if (_isPdf(url)) return 'PDF';
  if (_isImage(url)) return 'Image';
  return 'File';
}

// ── Main screen ───────────────────────────────────────────────────────────────
class CertificateDetailScreen extends StatefulWidget {
  final int certId;
  const CertificateDetailScreen({super.key, required this.certId});

  @override
  State<CertificateDetailScreen> createState() =>
      _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  CertificateModel? _cert;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c =
          await CertificateRepository().getCertificateDetail(widget.certId);
      if (mounted) setState(() => _cert = c);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Certificate',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(
                  error: _error!,
                  onRetry: () {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    _load();
                  },
                )
              : _CertificateDetailBody(cert: _cert!, isDark: isDark),
    );
  }
}

// ── Detail body ───────────────────────────────────────────────────────────────
class _CertificateDetailBody extends StatefulWidget {
  final CertificateModel cert;
  final bool isDark;
  const _CertificateDetailBody({required this.cert, required this.isDark});

  @override
  State<_CertificateDetailBody> createState() => _CertificateDetailBodyState();
}

class _CertificateDetailBodyState extends State<_CertificateDetailBody> {
  double? _progress; // null=idle, 0-1=downloading
  String? _localPath; // saved file path

  CertificateModel get cert => widget.cert;
  bool get isDark => widget.isDark;

  @override
  void initState() {
    super.initState();
    _checkExisting();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<String> _savePath(String url) async {
    // Public Downloads folder: /storage/emulated/0/Download/
    Directory? dir;
    try {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) dir.createSync(recursive: true);
    } catch (_) {
      dir = await getApplicationDocumentsDirectory();
    }
    final fileName = url.split('/').last.split('?').first;
    return '${dir.path}/$fileName';
  }

  Future<void> _checkExisting() async {
    if (cert.fileUrl == null) return;
    final path = await _savePath(cert.fileUrl!);
    if (File(path).existsSync()) {
      if (mounted) setState(() => _localPath = path);
    }
  }

  Future<bool> _requestPermission() async {
    // Android 13+ doesn't need WRITE for public Downloads via direct path
    // But for older Android we need it
    if (Platform.isAndroid) {
      final sdk = await _androidSdk();
      if (sdk <= 28) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  Future<int> _androidSdk() async {
    try {
      // Read from system property
      final result = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.tryParse(result.stdout.toString().trim()) ?? 30;
    } catch (_) {
      return 30;
    }
  }

  // ── Download ─────────────────────────────────────────────────────────────────
  Future<void> _downloadAndOpen() async {
    if (cert.fileUrl == null) return;

    // Already downloaded — open directly
    if (_localPath != null) {
      _openFile(_localPath!);
      return;
    }

    final granted = await _requestPermission();
    if (!granted) {
      Get.snackbar(
          'Permission Denied', 'Storage permission required to download.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white);
      return;
    }

    setState(() => _progress = 0.01);

    try {
      final fileName = cert.fileUrl!.split('/').last.split('?').first;
      final token = GetStorage().read<String>('auth_token');

      // Android DownloadManager — file appears in Files app automatically
      const channel = MethodChannel('com.example.ssvvostc/media_scan');
      final res = await channel.invokeMethod<Map>('download', {
        'url': cert.fileUrl!,
        'fileName': fileName,
        'token': token,
      });

      final savePath = res?['savePath'] as String?;
      if (mounted && savePath != null) {
        setState(() {
          _localPath = savePath;
          _progress = null;
        });
        Get.snackbar('Downloaded!', 'Saved to Downloads folder.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
        await Future.delayed(const Duration(milliseconds: 800));
        _openFile(savePath);
      }
    } catch (_) {
      // Fallback: Dio download
      await _downloadViaDio();
    }
  }

  Future<void> _downloadViaDio() async {
    try {
      final savePath = await _savePath(cert.fileUrl!);
      await ApiClient.instance.dio.download(
        cert.fileUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _progress = received / total);
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 3),
        ),
      );
      if (mounted) {
        setState(() {
          _localPath = savePath;
          _progress = null;
        });
        await _scanFile(savePath);
        Get.snackbar('Downloaded!', 'Saved to Downloads.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white);
        _openFile(savePath);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _progress = null);
        Get.snackbar('Download Failed', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
      }
    }
  }

  // ── Open file based on type ───────────────────────────────────────────────
  void _openFile(String path) {
    if (_isPdf(cert.fileUrl)) {
      Get.to(() => PdfViewerScreen(filePath: path, title: cert.title));
    } else if (_isImage(cert.fileUrl)) {
      Get.to(() => _ImageViewerScreen(path: path, title: cert.title));
    } else {
      OpenFilex.open(path);
    }
  }

  // Notify Android MediaStore so file appears in Files/Gallery app
  Future<void> _scanFile(String path) async {
    // Primary: MethodChannel (works after full rebuild)
    try {
      const channel = MethodChannel('com.example.ssvvostc/media_scan');
      await channel.invokeMethod('scan', {'path': path});
      return;
    } catch (_) {}

    // Fallback: OpenFilex triggers implicit media scan on some devices
    try {
      await OpenFilex.open(path);
    } catch (_) {}
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Preview area
          _PreviewBox(cert: cert, localPath: _localPath)
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppConstants.spaceLG),

          // Title
          Text(cert.title,
                  style: AppTextStyles.h1.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center)
              .animate(delay: 100.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceSM),

          Text(cert.course.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center)
              .animate(delay: 130.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),

          // Details
          _DetailCard(cert: cert, isDark: isDark)
              .animate(delay: 180.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppConstants.spaceLG),

          // Download / Open button
          if (cert.fileUrl != null) ...[
            if (_progress != null) ...[
              // Progress bar
              Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor:
                        isDark ? AppColors.borderDark : AppColors.borderLight,
                    color: AppColors.primary,
                    minHeight: 8,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Downloading... ${((_progress ?? 0) * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ] else ...[
              AppButton(
                label: _localPath != null
                    ? 'Open ${_fileLabel(cert.fileUrl)}'
                    : 'Download & Open ${_fileLabel(cert.fileUrl)}',
                onTap: _downloadAndOpen,
                icon: _localPath != null
                    ? _fileIcon(cert.fileUrl)
                    : Icons.download_rounded,
              ).animate(delay: 230.ms).fadeIn(duration: 400.ms),
              if (_localPath != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Saved in Downloads',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Re-download option
                    GestureDetector(
                      onTap: () {
                        setState(() => _localPath = null);
                      },
                      child: Text(
                        '(Re-download)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
            const SizedBox(height: AppConstants.spaceSM),
          ],

          // Verification URL
          if (cert.verificationUrl != null)
            AppButton(
              label: 'Copy Verification Link',
              isOutlined: true,
              onTap: () {
                Clipboard.setData(ClipboardData(text: cert.verificationUrl!));
                Get.snackbar('Copied!', 'Verification link copied.',
                    snackPosition: SnackPosition.BOTTOM);
              },
              icon: Icons.copy_rounded,
            ).animate(delay: 280.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: AppConstants.spaceLG),
        ],
      ),
    );
  }
}

// ── Preview box ───────────────────────────────────────────────────────────────
class _PreviewBox extends StatelessWidget {
  final CertificateModel cert;
  final String? localPath;
  const _PreviewBox({required this.cert, this.localPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        child: _buildPreview(),
      ),
    );
  }

  Widget _buildPreview() {
    // If image downloaded locally — show it
    if (_isImage(cert.fileUrl) && localPath != null) {
      return Image.file(File(localPath!), fit: BoxFit.contain);
    }
    // If image URL — show from network
    if (_isImage(cert.fileUrl) && cert.fileUrl != null) {
      return NetworkImageWidget(
        url: cert.fileUrl,
        fit: BoxFit.contain,
        placeholder: _FilePlaceholder(url: cert.fileUrl, title: cert.title),
      );
    }
    // PDF or other — show icon placeholder
    return _FilePlaceholder(url: cert.fileUrl, title: cert.title);
  }
}

class _FilePlaceholder extends StatelessWidget {
  final String? url;
  final String title;
  const _FilePlaceholder({this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final icon = _fileIcon(url);
    final color = _isPdf(url) ? AppColors.error : AppColors.primary;
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 38),
          ),
          const SizedBox(height: AppConstants.spaceMD),
          Text(
            '${_fileLabel(url)} Certificate',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.spaceMD),
            child: Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── In-app image viewer ───────────────────────────────────────────────────────
class _ImageViewerScreen extends StatelessWidget {
  final String path;
  final String title;
  const _ImageViewerScreen({required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: Get.back,
        ),
        title: Text(title,
            style: AppTextStyles.h3.copyWith(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.file(File(path), fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// ── Detail card ───────────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final CertificateModel cert;
  final bool isDark;
  const _DetailCard({required this.cert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _Row(
            label: 'Certificate Code',
            value: cert.certificateCode,
            isDark: isDark,
            valueStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
          _Divider(isDark: isDark),
          _Row(label: 'Issue Date', value: cert.issueDate, isDark: isDark),
          _Divider(isDark: isDark),
          _Row(
            label: 'Status',
            value: '',
            isDark: isDark,
            trailing: _StatusBadge(status: cert.status),
          ),
          if (cert.description != null) ...[
            _Divider(isDark: isDark),
            _Row(
                label: 'Description', value: cert.description!, isDark: isDark),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final TextStyle? valueStyle;
  final Widget? trailing;

  const _Row({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                )),
          ),
          Expanded(
            child: trailing ??
                Text(value,
                    style: valueStyle ??
                        AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        )),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
      );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'issued' ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: AppTextStyles.caption
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.spaceMD),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
