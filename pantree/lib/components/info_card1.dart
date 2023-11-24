import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String info;
  final String subtitle;
  final String? imageUrl;
  final double cardHeight;
  final TextStyle? titleTextStyle;
  final TextStyle? infoTextStyle;
  final TextStyle? subtitleTextStyle;
  final bool showIcon;
  final VoidCallback? onTap;

  const InfoCard({super.key, 
    required this.title,
    required this.info,
    required this.subtitle,
    this.imageUrl,
    this.cardHeight = 180.0,
    this.titleTextStyle,
    this.infoTextStyle,
    this.subtitleTextStyle,
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
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: cardHeight,
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -10.0,
            ),
          ],
          image: imageUrl != null
              ? DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.35),
                    BlendMode.multiply,
                  ),
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: titleTextStyle ?? theme.textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (showIcon) // Conditionally show the icon
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
                                style: infoTextStyle ??
                                    theme.textTheme.titleMedium),
                          ],
                        ),
                      ),
                    Text(
                      subtitle,
                      style: subtitleTextStyle ?? theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
