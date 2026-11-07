import 'package:flutter/material.dart';

/// بدنه‌ی اسکرول‌شونده با عرض حداکثر ۴۸۰ تا روی تبلت هم فرم کش نیاید.
class CenteredFormBody extends StatelessWidget {
  const CenteredFormBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
