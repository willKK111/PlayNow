import 'package:flutter/material.dart';

class MetricaCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  // Novos parâmetros opcionais para customização das cores
  final Color? backgroundColor;
  final Color? valueColor;
  final Color? titleColor;

  const MetricaCard({
    required this.title,
    required this.value,
    this.onTap,
    this.backgroundColor,
    this.valueColor,
    this.titleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: backgroundColor != null
                  ? (backgroundColor!.computeLuminance() > 0.5
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.2))
                  : colorScheme.primaryContainer,
              child: Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  color: valueColor ?? colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor ?? colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Clique para ver mais detalhes',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}
