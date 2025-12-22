import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? bottom;
  final double height;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const AdminAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.bottom,
    this.height = kToolbarHeight,
    this.actions,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).iconTheme.color, size: 20),
              onPressed: onBackPressed ?? () => Get.back(),
            )
          : null,
      centerTitle: true,
      title: Text(title, style: AppTextStyles.h3),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(height),
              child: bottom!,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? height + kToolbarHeight : height);
}
