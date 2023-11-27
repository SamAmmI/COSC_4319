import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/button.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/components/modern_text_box.dart';
import 'package:pantree/models/weight_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class WeightTrack extends StatefulWidget {
  const WeightTrack({
    super.key,
  });

  @override
  State<WeightTrack> createState() => _WeightTrackState();
}

class _WeightTrackState extends State<WeightTrack> {
  
  
  List<WeightData> data = [];
  
  final TextEditingController weightTextController = TextEditingController();
  int val = 100;
  String hintText = "Select your current body weight";
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String _userId;
  late CollectionReference weightLog;
  var userWeightLog;
  DateTime early = DateTime.now();
  DateTime late = DateTime(2023, 1, 1);
  int count = 0;
  @override
  void initState(){
    super.initState();
    _user = auth.currentUser!;
    _userId = _user.uid;
    weightLog = FirebaseFirestore.instance.collection('users').doc(_userId).collection('weightLog');
    _getUserWeightLog();
  }

  Future<List<WeightData>> getUserWeightLog() async{
    try{
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(_userId).collection('weightLog').orderBy('dateTime', descending: true).get();

      return snapshot.docs.map((doc) {
        final dat = doc.data();
        var hold = WeightData.fromMap(dat);
        if(early.compareTo(hold.date) > 0){
          early = hold.date;
        }
        return hold;
      }).toList();
    }catch(e){
      print('Error Fetching Weight Log: $e');
      return[];
    }
  }

  Future<void> _getUserWeightLog() async{
    List<WeightData> hold = await getUserWeightLog();
    
    setState(() {
      data = hold;
    });
  }

  int controllerToInt(){
    return int.parse(weightTextController.text);
  }
  
  bool checkDate(){
    for(var i in data){
      if(i.date.day == DateTime.now().day && i.date.month == DateTime.now().month && i.date.year == DateTime.now().year){
        return true;
      }
    }
    return false;
  }
  
  void onTap() async{
    if(weightTextController.text == ""){
      return;
    }
    count++;
    val = controllerToInt();
    if(checkDate() == true){
      setState((){});
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    WeightData wd = WeightData(date: DateTime.now(), weight: val);
      setState((){
        data.insert(0, wd);
        addWeightToUserFirebase(wd);
        addWeightToUserDatabase(uid, wd);
      });
  }

  Future<WeightData> addWeightToUserFirebase(WeightData wd) async{
    weightLog.doc(wd.date.toString()).set(wd.toMap());
    return wd;
  }

  Future<WeightData> addWeightToUserDatabase(String uid, WeightData wd) async{
    
    final now = DateTime.now();
    
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('weightLog').doc(wd.date.toString()).set({
      ...wd.toMap(),
      'dateTime': now,
    });
    
    return wd;
  }

  void addToUserDatabase(WeightData wd) async {
    try{
      await addWeightToUserDatabase(_userId, wd);
    }catch(e){
        print(e);
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Weight Tracking"),
      ),
      drawer: MyDrawer(
        onSignOutTap: () {  }, 
        onNutritionTap: () {  }, 
        onFoodInventoryTap: () {  }, 
        onSettingsTap: () {  },
        onRecipesTap: (){},
      ),
      body: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.days,
              rangePadding: ChartRangePadding.auto,
              minimum: early,
              maximum: DateTime.now()
            ),
            series: <ChartSeries<WeightData, DateTime>>[
              LineSeries(
                dataSource: data, 
                xValueMapper: (WeightData weight, _) => weight.date, 
                yValueMapper: (WeightData weight, _) => weight.weight,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.black,
                  borderColor: Colors.black
                )
              )
            ]
          ),
          ModernTextBox(
            controller: weightTextController,
            decoration: InputDecoration(labelText: "Enter Your Current Body Weight (kg)"),
            width: 350,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Visibility(
            child: Text("Please wait until tomorrow to log your weight"),
            visible: checkDate() && count > 0,
          ),
          MyButton(
            onTap: onTap, 
            text: "Log today's weight"
          )
          
        ],
      )
    );
  }
}