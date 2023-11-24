import 'package:pantree/models/user_profile.dart';
import 'package:pantree/services/user_service.dart';

class LocalUserManager {
  static final LocalUserManager userInstance = LocalUserManager.internal();

  factory LocalUserManager() {
    return userInstance;
  }

  LocalUserManager.internal();

  UserProfile? cachedUserProfile;
  final UserService userService = UserService();

  void cacheUserData(UserProfile user) {
    cachedUserProfile = user;
  }

  UserProfile? getCachedUser() {
    return cachedUserProfile;
  }

  // FETCH USER PROFILE FROM FIREBASE TO USE LOCALLY FOR FASTER RETRIEVAL AND LESS DEPENDENCE ON FIREBASE
  Future<void> fetchAndUpdateUser(String userId) async {
    try {
      UserProfile? profile = await UserService().getUserProfile(userId);
      if (profile != null) {
        cacheUserData(profile);
      }
    } catch (e) {
      print('error fetching user from firebase: $e');
    }
  }

  // UPDATE SPECIFIC ATTRIBUTE LOCALLY AND ON FIREBASE
  Future<void> updateUserAttribute(String attributeName, dynamic value) async {
    if (cachedUserProfile != null) {
      // Update the attribute in the local cache
      switch (attributeName) {
        case 'firstName':
          cachedUserProfile!.firstName = value;
        case 'lastName':
          cachedUserProfile!.lastName = value;
        case 'height':
          cachedUserProfile!.height = value as double?;
        case 'weight':
          cachedUserProfile!.weight = value as double?;
        case 'age':
          cachedUserProfile!.age = value as double?;
        case 'goalWeight':
          cachedUserProfile!.goalWeight = value as double?;
        case 'sex':
          cachedUserProfile!.sex = value as String?;
        case 'Calories':
          cachedUserProfile!.updateGoals('Calories', value);
        case 'Carbs':
          cachedUserProfile!.updateGoals('Carbs', value);
        case 'Protein':
          cachedUserProfile!.updateGoals('Protein', value);
        case 'Fat':
          cachedUserProfile!.updateGoals('Fat', value);
        default:
          return;
      }

      // PUSHING UPDATE TO FIREBASE USING '.setUserProfile' from user_service
      try {
        await userService.setUserProfile(cachedUserProfile!);
      } catch (e) {
        print('Error updating user profile in Firebase: $e');
      }
    }
  }

  // GETTER METHOD TO SPECIFIED ATTRIBUTE
  dynamic getUserAttribute(String attributeName) {
    if (cachedUserProfile == null) return null;

    switch (attributeName) {
      case 'userID':
        return cachedUserProfile!.userID;
      case 'firstName':
        return cachedUserProfile!.firstName;
      case 'lastName':
        return cachedUserProfile!.lastName;
      case 'height':
        return cachedUserProfile!.height;
      case 'age':
        return cachedUserProfile!.age;
      case 'goalWeight':
        return cachedUserProfile!.goalWeight;
      case 'sex':
        return cachedUserProfile!.sex;
      case 'Calories':
        return cachedUserProfile!.calorieGoal;
      case 'Carbs':
        return cachedUserProfile!.carbGoal;
      case 'Protein':
        return cachedUserProfile!.proteinGoal;
      case 'Fat':
        return cachedUserProfile!.fatGoal;
      default:
        return null;
    }
  }
}
