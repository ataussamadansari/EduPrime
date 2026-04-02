import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final _controller = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppColors.surfaceDark : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: const Color(0xFF424242),
      appBar: AppBar(
        backgroundColor: navBg,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: Get.back,
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.h3.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$_currentPage / $_totalPages',
                  style:
                      AppTextStyles.labelMedium.copyWith(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),

      body: PdfViewer.file(
        widget.filePath,
        controller: _controller,
        params: PdfViewerParams(
          backgroundColor: const Color(0xFF424242),
          // Track page changes via callback — no ValueListenableBuilder needed
          onPageChanged: (pageNumber) {
            if (mounted) {
              setState(() {
                _currentPage = pageNumber ?? 1;
                // pageCount available after document loads
                if (_controller.isReady) {
                  _totalPages = _controller.pageCount;
                }
              });
            }
          },
          onDocumentChanged: (doc) {
            if (mounted && doc != null) {
              setState(() {
                _totalPages = doc.pages.length;
                _currentPage = 1;
              });
            }
          },
        ),
      ),

      // Page navigation — only when >1 page
      bottomNavigationBar: _totalPages > 1
          ? Container(
              color: navBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.first_page_rounded,
                          color: Colors.white),
                      onPressed: _currentPage > 1
                          ? () => _controller.goToPage(pageNumber: 1)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded,
                          color: Colors.white),
                      onPressed: _currentPage > 1
                          ? () =>
                              _controller.goToPage(pageNumber: _currentPage - 1)
                          : null,
                    ),
                    Text(
                      '$_currentPage / $_totalPages',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white),
                      onPressed: _currentPage < _totalPages
                          ? () =>
                              _controller.goToPage(pageNumber: _currentPage + 1)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page_rounded,
                          color: Colors.white),
                      onPressed: _currentPage < _totalPages
                          ? () => _controller.goToPage(pageNumber: _totalPages)
                          : null,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
