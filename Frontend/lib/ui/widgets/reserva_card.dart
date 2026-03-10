import 'package:flutter/material.dart';

class ReservaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(String) onTap;

  const ReservaCard(this.title, this.subtitle, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onTap(title),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                title,
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
              ),
              subtitle: Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.square, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Icon(Icons.circle, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Icon(Icons.change_history, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
