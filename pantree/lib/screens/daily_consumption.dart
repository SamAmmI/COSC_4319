import 'package:flutter/material.dart';
import 'package:pantree/components/info_card1.dart';
import 'package:pantree/components/buildAppBar.dart';

class DailyConsumptionScreen extends StatelessWidget {
  const DailyConsumptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: BuildAppBar(
            title: 'Consumption Screen',
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/images/background2.png',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                5,
                (index) => Container(
                  width: 400,
                  child: InfoCard(
                    title: 'Card Title $index',
                    subtitle: 'Subtitle $index',
                    info: 'Info $index',
                    imageUrl: 'your_image_url',
                    cardHeight: 180.0,
                    showIcon: false,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
