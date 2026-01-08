import 'package:flutter/material.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({
    super.key,
    required this.title,
    required this.theme,
    this.centerTitle = true,
    this.onBackPressed,
    this.actions,
    this.height = kToolbarHeight,
  });

  final String title;
  final ThemeData theme;
  final bool? centerTitle;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: theme.textTheme.titleLarge),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 3,
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      centerTitle: centerTitle,
      leading: onBackPressed != null
          ? IconButton(
              onPressed: onBackPressed,
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + 1);
}
