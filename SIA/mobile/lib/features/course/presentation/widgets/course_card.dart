import 'package:flutter/material.dart';
import '../../data/course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurface.withOpacity(0.55);

    return Card(
      margin: EdgeInsets.zero,
      color: cs.surfaceContainer,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ردیف اول: عنوان | نشان ثبت‌نام | واحد و نوع
              Row(
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (course.isEnrolled) ...[
                    const SizedBox(width: 8),
                    _Badge(
                      text: 'ثبت‌نام شده',
                      background: Colors.green.shade100,
                      foreground: Colors.green.shade800,
                    ),
                  ],
                  const SizedBox(width: 8),
                  _Badge(
                    text: '${course.units} واحد • ${course.type}',
                    background: Colors.white,
                    foreground: const Color(0xFF1E3A8A),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                course.englishTitle,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 10),
              Text(
                course.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, height: 1.6, color: muted),
              ),
              const SizedBox(height: 12),
              // ردیف آخر: استاد | کد درس
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 16, color: cs.primary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            course.instructor,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: cs.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'کد درس: ${course.code}',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}