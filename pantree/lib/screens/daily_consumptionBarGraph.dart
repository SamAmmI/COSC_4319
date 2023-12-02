import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:pantree/models/local_user_manager.dart';
import 'package:pantree/models/user_profile.dart';
import 'package:pantree/services/user_consumption_service.dart';
import 'package:pantree/models/user_consumption_model.dart';

class DailyConsumptionScreenGraph extends StatefulWidget {
  const DailyConsumptionScreenGraph({Key? key}) : super(key: key);

  @override
  _DailyConsumptionScreenGraphState createState() =>
      _DailyConsumptionScreenGraphState();
}

class _DailyConsumptionScreenGraphState
    extends State<DailyConsumptionScreenGraph> {
  // attributes needed for this class
  UserConsumption? currentConsumption;
  UserProfile? userProfile;
  double? userCalorieGoal;
  double? userProteinGoal;
  double? userCarbGoal;
  double? userFatGoal;
  List<NutrientBarData> nutrientDataList = [];
  int? selectedNutrientIndex;

  @override
  void initState() {
    super.initState();
    fetchCurrentConsumption();
    fetchUserProfile();
  }

  void setSelectedNutrientIndex(int index) {
    setState(() {
      selectedNutrientIndex = index;
    });
  }

  // WHERE WE FETCH THE USER CURRENT CONSUMPTION
  Future<void> fetchCurrentConsumption() async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      DateTime currentDate = DateTime.now();
      var consumptionData = await ConsumptionService.instance
          .getUserConsumptionData(userID, currentDate);
      print('Fetched Data: $consumptionData');
      setState(() {
        currentConsumption = consumptionData;
      });
    } catch (e) {
      print('Error fetching consumption data: $e');
    }
  }

  // WHERE WE FETCH THE PROFILE AND ATTRIBUTES
  void fetchUserProfile() async {
    final localUserManager = LocalUserManager();
    userProfile = localUserManager.getCachedUser();

    if (userProfile == null) {
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
      await localUserManager.fetchAndUpdateUser(userID);
      userProfile = localUserManager.getCachedUser();
    }
    if (userProfile != null) {
      userCalorieGoal =
          localUserManager.getUserAttribute('Calories') as double?;
      userProteinGoal = localUserManager.getUserAttribute('Protein') as double?;
      userCarbGoal = localUserManager.getUserAttribute('Carbs') as double?;
      userFatGoal = localUserManager.getUserAttribute('Fat') as double?;
    }
    setState(() {});
  }

  List<NutrientBarData> generateNutrientData() {
    List<NutrientBarData> dataList = [];

    if (currentConsumption != null && userProfile != null) {
      // Extract the nutrient values from currentConsumption and userProfile

      double scaleCalories = 10;
      double currentCalories =
          (currentConsumption!.totalCalories) / scaleCalories;
      double currentProteins = currentConsumption!.totalProteins;
      double currentCarbs = currentConsumption!.totalCarbs;
      double currentFats = currentConsumption!.totalFats;

      double goalCalories = (userCalorieGoal ?? 0) / scaleCalories;
      double goalProteins = userProteinGoal ?? 0;
      double goalCarbs = userCarbGoal ?? 0;
      double goalFats = userFatGoal ?? 0;

      // Create NutrientBarData instances for each nutrient
      dataList.add(NutrientBarData('Calories', currentCalories, goalCalories));
      dataList.add(NutrientBarData('Proteins', currentProteins, goalProteins));
      dataList.add(NutrientBarData('Carbs', currentCarbs, goalCarbs));
      dataList.add(NutrientBarData('Fats', currentFats, goalFats));
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    nutrientDataList = generateNutrientData();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
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
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.black ??
                                  Colors.white,
                            ),
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return NutrientBarChart(
                                  dataList: nutrientDataList,
                                  selectedIndex: selectedNutrientIndex,
                                );
                              }, // Removed Expanded),
                            ),
                          ))
                    ],
                  )),

              //WHERE NUTRITIONAL SUMMARY BEGINS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 25, 0, 4),
                    child: Text(
                      'Nutritional Summary',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 10),
                    child: Text(
                      'Overview of your daily consumption.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNutrientCard(
                          'Calories',
                          '${currentConsumption?.totalCalories.toStringAsFixed(0)} kcal',
                          0),
                      buildNutrientCard(
                          'Proteins',
                          '${currentConsumption?.totalProteins.toStringAsFixed(0)} g',
                          1),
                      buildNutrientCard(
                          'Carbs',
                          '${currentConsumption?.totalCarbs.toStringAsFixed(0)} g',
                          2),
                      buildNutrientCard(
                          'Fats',
                          '${currentConsumption?.totalFats.toStringAsFixed(0)} g',
                          3),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// widget for each nutrient card such as calories, and others....
  Widget buildNutrientCard(String nutrient, String value, int index) {
    return GestureDetector(
      onTap: () {
        showTooltipForNutrient(index);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor ??
                Colors.black ??
                Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Color(0xFFE0E3E7),
                offset: Offset(0, .2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nutrient,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTooltipForNutrient(int index) {
    setState(() {
      selectedNutrientIndex = index;
    });
  }
}

class NutrientBarData {
  final String nutrient;
  final double consumption;
  final double goal;

  NutrientBarData(this.nutrient, this.consumption, this.goal);
}

class NutrientBarChart extends StatefulWidget {
  final List<NutrientBarData> dataList;
  final int? selectedIndex;
  final ValueChanged<int?>? onBarTapped;

  NutrientBarChart({
    Key? key,
    required this.dataList,
    this.selectedIndex,
    this.onBarTapped,
  }) : super(key: key);

  @override
  _NutrientBarChartState createState() => _NutrientBarChartState();
}

class _NutrientBarChartState extends State<NutrientBarChart>
    implements TickerProvider {
  int? selectedNutrientIndex;
  late AnimationController animationController;
  final Curve curve = Curves.easeInOut;
  final Tween<double> barTween = Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1), // Adjust the duration as needed
      vsync: this,
    );

    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  double calculateMaxY() {
    double maxValue = 0;
    for (var data in widget.dataList) {
      maxValue = max(maxValue, data.consumption);
      maxValue = max(maxValue, data.goal);
    }
    return maxValue + 100; // Adding a margin of 100
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = Text('Calories');
                    break;
                  case 1:
                    text = Text('Proteins');
                    break;
                  case 2:
                    text = Text('Carbs');
                    break;
                  case 3:
                    text = Text('Fats');
                    break;
                  default:
                    text = Text('');
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: text,
                );
              },
            ),
          ),
        ),
        maxY: calculateMaxY(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String nutrient = widget.dataList[groupIndex].nutrient;
                double actualValue = widget.dataList[groupIndex].consumption;
                double goalValue = widget.dataList[groupIndex].goal;

                // rescale calories because it was scaled for improvement visually
                if (nutrient == 'Calories') {
                  actualValue *= 10;
                  goalValue *= 10;
                }

                return BarTooltipItem(
                  '$nutrient\nCurrent: ${actualValue.round()}\nGoal: ${goalValue.round()}',
                  TextStyle(color: Colors.white),
                );
              },
            )),
        barGroups: widget.dataList
            .asMap()
            .map((index, data) {
              return MapEntry(
                index,
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.consumption *
                          barTween.evaluate(animationController),
                      color: Colors.blue,
                      width: 16,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                    BarChartRodData(
                      toY: data.goal * barTween.evaluate(animationController),
                      color: Colors.green,
                      width: 16,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                  ],
                  //showingTooltipIndicators:
                  //widget.selectedIndex == index ? [index] : [],
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
