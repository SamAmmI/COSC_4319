import 'package:flutter/material.dart';

class VerticalInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String info;
  final String imageUrl;
  final double cardWidth;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? infoTextStyle;
  final bool showIcon;
  final VoidCallback? onTap;

  const VerticalInfoCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.info,
    required this.imageUrl,
    this.cardWidth = 200.0,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.infoTextStyle,
    this.showIcon = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color cardBackgroundColor =
        Theme.of(context).appBarTheme.backgroundColor ??
            Colors.black ??
            Colors.white;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(0.0, 10.0),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Text(
                title,
                style: titleTextStyle ?? theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            if (showIcon)
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardBackgroundColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(info,
                        style: infoTextStyle ?? theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Colors.yellow,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Text(subtitle,
                      style: subtitleTextStyle ?? theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
