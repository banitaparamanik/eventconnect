import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

// lib/presentation/chat_list/widgets/chat_search_header_widget.dart

class ChatSearchHeaderWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const ChatSearchHeaderWidget({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const CustomIconWidget(
            iconName: 'search',
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const CustomIconWidget(
                    iconName: 'clear',
                    size: 20,
                  ),
                  onPressed: onClear,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 1.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
