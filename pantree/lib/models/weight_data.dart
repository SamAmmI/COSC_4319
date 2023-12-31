import 'package:cloud_firestore/cloud_firestore.dart';

class WeightData{
  DateTime date;
  int weight;

  WeightData({
    required this.date,
    required this.weight
  });

  Map<String, dynamic> toMap(){
    return{
      'date': date,
      'weight': weight
    };
  }

 factory WeightData.fromMap(Map<String, dynamic> map) {
    return WeightData(
      date: (map['dateTime']).toDate(),
      weight: map['weight']?.toInt()
    );
  }
}