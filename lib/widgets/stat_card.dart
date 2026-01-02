import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: iconColor ?? AppTheme.getTextSecondary(context),
                ),
                const SizedBox(width: AppTheme.spacingSm),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
