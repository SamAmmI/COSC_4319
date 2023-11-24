import 'package:flutter/material.dart';

/*
this class will display a visual representation of the user's consumption,
the user will also be able to navigate to a more specific page
*/
class DailyConsumptionScreenGraph extends StatefulWidget {
  const DailyConsumptionScreenGraph({Key? key}) : super(key: key);

  @override
  State<DailyConsumptionScreenGraph> createState() =>
      _DailyConsumptionScreenGraphState();
}

class _DailyConsumptionScreenGraphState
    extends State<DailyConsumptionScreenGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Consumption',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
                height: 340,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).appBarTheme.backgroundColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                          child: Text(
                            'Daily Overview',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize ??
                                  16,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontWeight,
                            ),
                          ),
                        )
                        // here is where you need to add arrow to navigate to other page
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        height: 270,
                        width: 345,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.orange,
                        ),
                      ),
                    ),

                    // START here to add the bar chart

                    // then start here to add the arrow to take you to the other page
                  ],
                )),

            //WHERE NUTRITIONAL SUMMARY BEGINS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 25, 0, 4),
                  child: Text(
                    'Nutritional Summary',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 10),
                  child: Text(
                    'Overview of your daily consumption.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNutrientCard('Calories', '2000 kcal'),
                    buildNutrientCard('Proteins', '50 g'),
                    buildNutrientCard('Carbs', '300 g'),
                    buildNutrientCard('Fats', '70 g'),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNutritionalSummary(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .scaffoldBackgroundColor, // Use scaffold background color
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor ??
                    Colors.black ??
                    Colors.white, // You can customize the color here
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNutrientCard(String nutrient, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        width: double.infinity, // Extend the width to fit the container
        height: 60, // Adjust height as needed
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ??
              Colors.black ??
              Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color(0xFFE0E3E7),
              offset: Offset(0, .2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nutrient,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
