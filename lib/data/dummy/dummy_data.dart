import '../models/course_model.dart';
import '../models/assignment_model.dart';
import '../models/exam_model.dart';

class DummyData {
  // ── Courses ──────────────────────────────────────────────────────────────
  static final List<CourseModel> courses = [
    const CourseModel(
      id: '1',
      title: 'Flutter & Dart – Complete Developer Bootcamp',
      instructor: 'Dr. Angela Yu',
      thumbnail: 'https://picsum.photos/seed/flutter/400/220',
      price: 2999,
      rating: 4.8,
      reviewCount: 12400,
      duration: '42 hours',
      category: 'Development',
      totalLessons: 120,
      completedLessons: 45,
      isEnrolled: true,
      progress: 0.37,
      lastAccessed: '2 hours ago',
      description:
          'Master Flutter from scratch. Build beautiful cross-platform apps for iOS, Android, and Web with Dart. Includes real-world projects, animations, and state management.',
      curriculum: [
        CurriculumSection(title: 'Getting Started', lessons: [
          LessonModel(
              title: 'Introduction to Flutter',
              duration: '5:20',
              isCompleted: true),
          LessonModel(
              title: 'Setting Up Environment',
              duration: '8:45',
              isCompleted: true),
          LessonModel(
              title: 'Your First Flutter App',
              duration: '12:10',
              isCompleted: true),
        ]),
        CurriculumSection(title: 'Dart Fundamentals', lessons: [
          LessonModel(
              title: 'Variables & Data Types',
              duration: '10:30',
              isCompleted: true),
          LessonModel(
              title: 'Functions & Classes',
              duration: '14:20',
              isCompleted: false),
          LessonModel(
              title: 'Async Programming', duration: '18:00', isLocked: true),
        ]),
        CurriculumSection(title: 'Flutter Widgets', lessons: [
          LessonModel(
              title: 'Stateless vs Stateful', duration: '9:15', isLocked: true),
          LessonModel(
              title: 'Layout Widgets', duration: '16:40', isLocked: true),
        ]),
      ],
      reviews: [
        ReviewModel(
          name: 'Rahul Sharma',
          rating: 5,
          comment:
              'Best Flutter course I have ever taken. Very detailed and practical.',
          date: 'Dec 2024',
          avatar: 'https://i.pravatar.cc/60?img=1',
        ),
        ReviewModel(
          name: 'Priya Patel',
          rating: 4.5,
          comment:
              'Excellent content. The projects are very helpful for building portfolio.',
          date: 'Nov 2024',
          avatar: 'https://i.pravatar.cc/60?img=5',
        ),
      ],
    ),
    const CourseModel(
      id: '2',
      title: 'UI/UX Design Masterclass 2024',
      instructor: 'Sarah Johnson',
      thumbnail: 'https://picsum.photos/seed/design/400/220',
      price: 1999,
      rating: 4.7,
      reviewCount: 8900,
      duration: '28 hours',
      category: 'Design',
      totalLessons: 85,
      completedLessons: 20,
      isEnrolled: true,
      progress: 0.24,
      lastAccessed: '1 day ago',
      description:
          'Learn professional UI/UX design using Figma. Cover user research, wireframing, prototyping, and design systems used by top companies.',
      curriculum: [
        CurriculumSection(title: 'Design Fundamentals', lessons: [
          LessonModel(
              title: 'Principles of Good Design',
              duration: '7:30',
              isCompleted: true),
          LessonModel(
              title: 'Color Theory', duration: '11:20', isCompleted: true),
          LessonModel(
              title: 'Typography Basics', duration: '9:45', isCompleted: false),
        ]),
        CurriculumSection(title: 'Figma Essentials', lessons: [
          LessonModel(
              title: 'Figma Interface Tour', duration: '6:00', isLocked: true),
          LessonModel(
              title: 'Components & Variants',
              duration: '15:30',
              isLocked: true),
        ]),
      ],
      reviews: [
        ReviewModel(
          name: 'Amit Kumar',
          rating: 5,
          comment: 'Sarah explains everything so clearly. Highly recommended!',
          date: 'Jan 2025',
          avatar: 'https://i.pravatar.cc/60?img=3',
        ),
      ],
    ),
    const CourseModel(
      id: '3',
      title: 'Machine Learning with Python',
      instructor: 'Prof. Andrew Ng',
      thumbnail: 'https://picsum.photos/seed/ml/400/220',
      price: 3499,
      rating: 4.9,
      reviewCount: 22000,
      duration: '56 hours',
      category: 'Data Science',
      totalLessons: 160,
      completedLessons: 0,
      isEnrolled: false,
      progress: 0.0,
      lastAccessed: '',
      description:
          'Comprehensive ML course covering supervised learning, neural networks, deep learning, and real-world applications using Python, TensorFlow, and scikit-learn.',
      curriculum: [
        CurriculumSection(title: 'Python for ML', lessons: [
          LessonModel(
              title: 'NumPy & Pandas', duration: '14:00', isLocked: true),
          LessonModel(
              title: 'Data Visualization', duration: '12:30', isLocked: true),
        ]),
        CurriculumSection(title: 'Supervised Learning', lessons: [
          LessonModel(
              title: 'Linear Regression', duration: '18:00', isLocked: true),
          LessonModel(
              title: 'Classification Algorithms',
              duration: '22:00',
              isLocked: true),
        ]),
      ],
      reviews: [
        ReviewModel(
          name: 'Neha Singh',
          rating: 5,
          comment: 'World-class content. Andrew Ng is the best ML teacher.',
          date: 'Feb 2025',
          avatar: 'https://i.pravatar.cc/60?img=9',
        ),
      ],
    ),
    const CourseModel(
      id: '4',
      title: 'Full Stack Web Development',
      instructor: 'Colt Steele',
      thumbnail: 'https://picsum.photos/seed/webdev/400/220',
      price: 2499,
      rating: 4.6,
      reviewCount: 15600,
      duration: '63 hours',
      category: 'Development',
      totalLessons: 200,
      completedLessons: 0,
      isEnrolled: false,
      progress: 0.0,
      lastAccessed: '',
      description:
          'Learn HTML, CSS, JavaScript, Node.js, React, and MongoDB. Build full-stack web applications from scratch with real-world projects.',
      curriculum: [
        CurriculumSection(title: 'HTML & CSS', lessons: [
          LessonModel(
              title: 'HTML Fundamentals', duration: '8:00', isLocked: true),
          LessonModel(
              title: 'CSS Flexbox & Grid', duration: '16:00', isLocked: true),
        ]),
      ],
      reviews: [],
    ),
    const CourseModel(
      id: '5',
      title: 'Digital Marketing Strategy',
      instructor: 'Neil Patel',
      thumbnail: 'https://picsum.photos/seed/marketing/400/220',
      price: 1499,
      rating: 4.5,
      reviewCount: 6700,
      duration: '18 hours',
      category: 'Marketing',
      totalLessons: 60,
      completedLessons: 0,
      isEnrolled: false,
      progress: 0.0,
      lastAccessed: '',
      description:
          'Master SEO, social media marketing, email campaigns, and paid advertising. Learn to grow businesses online with proven strategies.',
      curriculum: [],
      reviews: [],
    ),
    const CourseModel(
      id: '6',
      title: 'AWS Cloud Practitioner',
      instructor: 'Stephane Maarek',
      thumbnail: 'https://picsum.photos/seed/aws/400/220',
      price: 2799,
      rating: 4.8,
      reviewCount: 19200,
      duration: '35 hours',
      category: 'Cloud',
      totalLessons: 110,
      completedLessons: 0,
      isEnrolled: false,
      progress: 0.0,
      lastAccessed: '',
      description:
          'Prepare for the AWS Cloud Practitioner certification. Covers core AWS services, security, pricing, and cloud concepts.',
      curriculum: [],
      reviews: [],
    ),
  ];

  // ── Enrolled courses only ─────────────────────────────────────────────────
  static List<CourseModel> get enrolledCourses =>
      courses.where((c) => c.isEnrolled).toList();

  // ── Banners ───────────────────────────────────────────────────────────────
  static final List<Map<String, String>> banners = [
    {
      'title': '50% OFF on All Courses',
      'subtitle': 'Limited time offer. Enroll today!',
      'color': '6C63FF',
      'image': 'https://picsum.photos/seed/banner1/600/200',
    },
    {
      'title': 'New Batch Starting April 1',
      'subtitle': 'Flutter & React Native – Register Now',
      'color': 'FF6584',
      'image': 'https://picsum.photos/seed/banner2/600/200',
    },
    {
      'title': 'Live Doubt Sessions',
      'subtitle': 'Every Saturday 6 PM – Join Free',
      'color': '43E97B',
      'image': 'https://picsum.photos/seed/banner3/600/200',
    },
  ];

  // ── Assignments ───────────────────────────────────────────────────────────
  static final List<AssignmentModel> assignments = [
    const AssignmentModel(
      id: 'a1',
      title: 'Build a Todo App in Flutter',
      courseName: 'Flutter & Dart Bootcamp',
      dueDate: 'Apr 5, 2025',
      status: AssignmentStatus.pending,
      totalMarks: 100,
      description:
          'Create a fully functional Todo app using Flutter with GetX state management.',
    ),
    const AssignmentModel(
      id: 'a2',
      title: 'Design a Mobile App Wireframe',
      courseName: 'UI/UX Design Masterclass',
      dueDate: 'Apr 3, 2025',
      status: AssignmentStatus.submitted,
      totalMarks: 50,
      description: 'Create wireframes for a food delivery app using Figma.',
    ),
    const AssignmentModel(
      id: 'a3',
      title: 'Linear Regression Implementation',
      courseName: 'Machine Learning with Python',
      dueDate: 'Mar 28, 2025',
      status: AssignmentStatus.graded,
      score: 88,
      totalMarks: 100,
      description: 'Implement linear regression from scratch using NumPy.',
    ),
    const AssignmentModel(
      id: 'a4',
      title: 'CSS Responsive Layout',
      courseName: 'Full Stack Web Development',
      dueDate: 'Mar 20, 2025',
      status: AssignmentStatus.overdue,
      totalMarks: 75,
      description:
          'Build a responsive landing page using CSS Grid and Flexbox.',
    ),
  ];

  // ── Exams ─────────────────────────────────────────────────────────────────
  static final List<ExamModel> exams = [
    const ExamModel(
      id: 'e1',
      title: 'Flutter Mid-Term Exam',
      courseName: 'Flutter & Dart Bootcamp',
      date: 'Apr 10, 2025',
      time: '10:00 AM',
      duration: '2 hours',
      status: ExamStatus.upcoming,
      totalMarks: 100,
      venue: 'Online – Zoom',
    ),
    const ExamModel(
      id: 'e2',
      title: 'UI/UX Design Quiz',
      courseName: 'UI/UX Design Masterclass',
      date: 'Apr 15, 2025',
      time: '2:00 PM',
      duration: '1 hour',
      status: ExamStatus.upcoming,
      totalMarks: 50,
      venue: 'Online – Google Meet',
    ),
    const ExamModel(
      id: 'e3',
      title: 'Dart Fundamentals Test',
      courseName: 'Flutter & Dart Bootcamp',
      date: 'Mar 15, 2025',
      time: '11:00 AM',
      duration: '1.5 hours',
      status: ExamStatus.completed,
      score: 92,
      totalMarks: 100,
      venue: 'Online – Zoom',
    ),
    const ExamModel(
      id: 'e4',
      title: 'Design Principles Assessment',
      courseName: 'UI/UX Design Masterclass',
      date: 'Mar 5, 2025',
      time: '3:00 PM',
      duration: '45 minutes',
      status: ExamStatus.completed,
      score: 78,
      totalMarks: 100,
      venue: 'Online – Google Meet',
    ),
  ];

  // ── Attendance (month map: day -> present/absent) ─────────────────────────
  static final Map<int, bool> marchAttendance = {
    1: true,
    2: true,
    3: false,
    4: true,
    5: true,
    6: true,
    7: false,
    8: true,
    9: true,
    10: true,
    11: true,
    12: true,
    13: false,
    14: true,
    15: true,
    16: false,
    17: true,
    18: true,
    19: true,
    20: true,
    21: true,
    22: false,
    23: true,
    24: true,
    25: true,
    26: true,
    27: true,
    28: false,
    29: true,
    30: true,
    31: true,
  };

  // ── Categories ────────────────────────────────────────────────────────────
  static const List<String> categories = [
    'All',
    'Development',
    'Design',
    'Data Science',
    'Marketing',
    'Cloud',
  ];

  // ── User profile ──────────────────────────────────────────────────────────
  static const Map<String, dynamic> userProfile = {
    'name': 'Arjun Mehta',
    'email': 'arjun.mehta@email.com',
    'phone': '+91 98765 43210',
    'avatar': 'https://i.pravatar.cc/150?img=12',
    'enrolledCourses': 2,
    'completedCourses': 0,
    'certificates': 0,
    'attendancePercent': 84,
    'pendingAssignments': 2,
    'joinedDate': 'January 2025',
  };
}
