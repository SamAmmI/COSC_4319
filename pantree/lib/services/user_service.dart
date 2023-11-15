import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantree/models/user_profile.dart';

class UserService {
  final FirebaseFirestore userTable = FirebaseFirestore.instance;

  //METHOD TO CREATE OR UPDATE USER PROFILE IN FIREBASE
  Future<void> setUserProfile(UserProfile userProfile) async {
    await userTable
        .collection('users')
        .doc(userProfile.userID)
        .set(userProfile.toMap());
  }

  //METHOD TO FETCH USER PROFILE FROM FIREBASE
  Future<UserProfile?> getUserProfile(String userID) async {
    DocumentSnapshot userDoc =
        await userTable.collection('users').doc(userID).get();

    if (userDoc.exists && userDoc.data() != null) {
      return UserProfile.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  //Method to fetch specified attribute from the user table based 'uid'
  Future<dynamic> fetchUserAttribute(
      String userID, String attributeName) async {
    DocumentSnapshot userDoc =
        await userTable.collection('users').doc(userID).get();

    if (userDoc.exists && userDoc.data() != null) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData[attributeName];
    } else {
      return null;
    }
  }
}
