import 'package:flutter/material.dart';

enum InfoCardIconType {
  star,
  schedule,
  none,
}

class VerticalInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String info;
  final String imageUrl;
  final double cardWidth;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle infoTextStyle;
  final InfoCardIconType iconType;
  final VoidCallback? onTap;

  VerticalInfoCard({
    required this.title,
    required this.subtitle,
    required this.info,
    required this.imageUrl,
    this.cardWidth = 200.0,
    this.titleTextStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    this.subtitleTextStyle = const TextStyle(fontSize: 14),
    this.infoTextStyle = const TextStyle(fontSize: 14),
    this.iconType = InfoCardIconType.star, // Set the default icon type
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
              offset: Offset(0.0, 10.0),
              blurRadius: 4.0,
              spreadRadius: -8.0,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Text(
                title,
                style: titleTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            if (iconType != InfoCardIconType.none)
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardBackgroundColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      iconType == InfoCardIconType.star
                          ? Icons.star
                          : Icons.schedule,
                      color: Colors.yellow,
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Text(info, style: infoTextStyle),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(subtitle, style: subtitleTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
