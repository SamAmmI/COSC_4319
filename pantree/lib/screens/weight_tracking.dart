import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/components/settings_drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightTrack extends StatefulWidget {
  const WeightTrack({super.key});

  @override
  State<WeightTrack> createState() => _WeightTrackState();
}

class _WeightTrackState extends State<WeightTrack> {
  List<WeightData> data = [
    WeightData(DateTime(11 - 08 - 2023), 200),
    WeightData(DateTime(11 - 07 - 2023), 201),
    WeightData(DateTime(11 - 06 - 2023), 195),
  ];

  final TextEditingController weightTextController = TextEditingController();
  List<int> weightEntries = [100];
  int val = 100;
  String hintText = "Select your current body weight";
  @override
  void initState() {
    super.initState();
    for (int i = 101; i < 300; i++) {
      weightEntries.add(i);
    }
  }

  void onTap() {
    setState(() {
      for (int i = 0; i < data.length; i++) {
        if (DateTime.now().month == data[i].x.month &&
            DateTime.now().day == data[i].x.day &&
            DateTime.now().year == data[i].x.day) {
          const Text("Please wait until tomorrow to update your body weight");
        }
      }
      data.add(WeightData(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          val));
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("Weight Tracking"),
        ),
        drawer: Settings_Drawer(
          onSettingsTap: () {
            // Navigate to settings screen (optional: can implement additional logic if needed)
          },
        ),
        body: Column(
          children: [
            SfCartesianChart(
                primaryXAxis:
                    DateTimeAxis(intervalType: DateTimeIntervalType.days),
                series: <ChartSeries<WeightData, DateTime>>[
                  LineSeries(
                      dataSource: data,
                      xValueMapper: (WeightData weight, _) => weight.x,
                      yValueMapper: (WeightData weight, _) => weight.y)
                ]),
            DropdownButton<int>(
              hint: Text(hintText),
              items: weightEntries.map((int val) {
                return DropdownMenuItem<int>(
                    value: val,
                    child: Text(val.toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)));
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  val = value!;
                  hintText = val.toString();
                });
              },
            ),
            MyButton(onTap: onTap, text: "Enter new weight")
          ],
        ));
  }
}

class WeightData {
  WeightData(this.x, this.y);
  DateTime x;
  int y;
}
