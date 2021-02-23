// import '../../data/activity/activity.dart';
// import '../../data/activity/planter_activity.dart';
// import '../../data/chat.dart';
// import '../../data/login_response.dart';
// import '../../data/message.dart';
// import '../../data/plant.dart';
// import '../../data/planter.dart';
// import '../../data/planter_canvas.dart';
// import '../../data/planter_checkin.dart';
// import '../../data/planter_friend.dart';
// import '../../data/planter_notification.dart';
// import '../../data/search_results.dart';
// import '../api.dart';
// import 'data/mock_activity_data.dart';
// import 'data/mock_canvas_data.dart';
// import 'data/mock_messages_data.dart';
// import 'data/mock_notification_data.dart';
// import 'data/mock_plant_data.dart';
// import 'data/mock_planter_data.dart';
// import 'data/mock_search_data.dart';

// class MockApi implements Api {
//   final Duration loadingDuration;

//   MockApi({this.loadingDuration = const Duration(milliseconds: 600)});

//   @override
//   Future<List<Activity>> fetchActivities({String sortedBy, int limit}) async {
//     await Future.delayed(loadingDuration);
//     final activities =
//         sortedBy == 'likes' ? dummyMostLikedActivities : dummyActivities;
//     final result = activities.only(limit);

//     return result.map((e) => Activity.fromJson(e)).toList();
//   }

//   @override
//   Future<Activity> fetchActivity(String activityId) async {
//     await Future.delayed(loadingDuration);
//     final activity = dummyActivities.firstWhere((a) => a['id'] == activityId,
//         orElse: () => dummyActivity);
//     return Activity.fromJson(activity);
//   }

//   @override
//   Future<Plant> fetchPlant(String plantId) async {
//     await Future.delayed(loadingDuration);
//     return Plant.fromJson(dummyPlant);
//   }

//   @override
//   Future<Planter> fetchPlanter(String planterId) async {
//     await Future.delayed(loadingDuration);
//     return Planter.fromJson(dummyPlanter);
//   }

//   @override
//   Future<PlanterCanvas> fetchPlanterCanvas(String planterId) async {
//     await Future.delayed(loadingDuration);
//     return PlanterCanvas.fromJson(dummyCanvas);
//   }

//   @override
//   Future<List<Planter>> fetchPlanters(
//       {String sortedBy, int limit, List<String> ids}) async {
//     await Future.delayed(loadingDuration);
//     // throw Exception('Try again later');
//     final planters =
//         sortedBy == 'activity' ? dummyMostActivePlanters : dummyPlanters;
//     final result = planters.only(limit);
//     return result.map((e) => Planter.fromJson(e)).toList();
//   }

//   @override
//   Future<List<Plant>> fetchPlants(
//       {String sortedBy, int limit, List<String> ids}) async {
//     await Future.delayed(loadingDuration);
//     final result = dummyPlants.only(limit);
//     return result.map((e) => Plant.fromJson(e)).toList();
//   }

//   @override
//   Future<SearchResults> searchActivities({String keyword, int limit}) async {
//     await Future.delayed(loadingDuration);
//     return SearchResults.fromJson(dummySearchResults);
//   }

//   @override
//   Future<List<PlanterActivity>> fetchPlanterActivities(String planterId) async {
//     await Future.delayed(loadingDuration);
//     return dummyPlanterActivities
//         .map((e) => PlanterActivity.fromJson(e))
//         .toList();
//   }

//   @override
//   Future<List<PlanterNotification>> fetchPlanterNotifications(
//       String planterId) async {
//     await Future.delayed(loadingDuration);
//     return dummyNotifications
//         .map((e) => PlanterNotification.fromJson(e))
//         .toList();
//   }

//   @override
//   Future<PlanterActivity> fetchPlanterActivity(
//       String planterId, String activityId) async {
//     await Future.delayed(loadingDuration);
//     final result = dummyPlanterActivities.firstWhere(
//         (a) => a['activityId'] == activityId,
//         orElse: () => dummyPlanterActivity);
//     return PlanterActivity.fromJson(result);
//   }

//   @override
//   Future<List<PlanterCheckIn>> fetchPlanterCheckIns(
//       String planterId, int month, int year, String token) async {
//     await Future.delayed(loadingDuration);
//     return dummyPlanterCheckIns
//         .where((e) {
//           final eventDate = DateTime.parse(e['timestamp'] as String);
//           return eventDate.year == year && eventDate.month == month;
//         })
//         .map((e) => PlanterCheckIn.fromJson(e))
//         .toList();
//   }

//   @override
//   Future<List<PlanterFriend>> fetchPlanterFriends(String planterId) async {
//     await Future.delayed(loadingDuration);
//     return dummyPlanterFriends.map((e) => PlanterFriend.fromJson(e)).toList();
//   }

//   @override
//   Future<PlanterCheckIn> logPlanterCheckIn(
//       String planterId, PlanterCheckIn checkIn) async {
//     await Future.delayed(loadingDuration);
//     return checkIn;
//   }

//   @override
//   Future<String> inviteFriend(String email, String name, String comment) async {
//     await Future.delayed(loadingDuration);
//     return 'https://wadi.green/api/something';
//   }

//   @override
//   Future<LoginResponse> login(String username, String password) async {
//     await Future.delayed(loadingDuration);
//     return LoginResponse(
//       accessToken: 'abc.123.xyz',
//       refreshToken: 'abc.123.xyz',
//       expiryDate: DateTime.now().add(const Duration(days: 90)),
//     );
//   }

//   @override
//   Future<String> signUp(String username, String password) async {
//     await Future.delayed(loadingDuration);
//     return 'https://wadi.green/api/something';
//   }

//   @override
//   Future<List<Message>> fetchGroupMessages(
//       String planterId, String messageGroupId) async {
//     await Future.delayed(loadingDuration);
//     return dummyMessages.map((e) => Message.fromJson(e)).toList();
//   }

//   @override
//   Future<Message> sendMessageToGroup(
//       Message message, String planterId, String messageGroupId) async {
//     await Future.delayed(loadingDuration);
//     return message;
//   }

//   @override
//   Future<List<Chat>> fetchAllGroups(String planterId) async {
//     await Future.delayed(loadingDuration);
//     return dummyChats.map((e) => Chat.fromJson(e)).toList();
//   }
// }

// extension ListUtils<T> on List<T> {
//   List<T> only(int count) {
//     if (count == null) {
//       return this;
//     }
//     return length > count ? take(count).toList() : this;
//   }
// }
