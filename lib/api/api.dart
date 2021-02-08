import '../data/activity/activity.dart';
import '../data/activity/planter_activity.dart';
import '../data/chat.dart';
import '../data/login_response.dart';
import '../data/message.dart';
import '../data/plant.dart';
import '../data/planter.dart';
import '../data/planter_canvas.dart';
import '../data/planter_checkin.dart';
import '../data/planter_friend.dart';
import '../data/planter_notification.dart';
import '../data/search_results.dart';

/// Interface defining the functions that need to be present both inside the
/// mock API and the actual API
abstract class Api {
  /// Plants Requests
  Future<List<Plant>> fetchPlants({String sortedBy, int limit, List<String> ids});
  Future<Plant> fetchPlant(String plantId);

  /// Planters Requests
  Future<List<Planter>> fetchPlanters({String sortedBy, int limit, List<String> ids});
  Future<Planter> fetchPlanter(String planterId);
  Future<List<PlanterFriend>> fetchPlanterFriends(String planterId);
  Future<List<PlanterActivity>> fetchPlanterActivities(String planterId);
  Future<PlanterActivity> fetchPlanterActivity(String planterId, String activityId);
  Future<PlanterCanvas> fetchPlanterCanvas(String planterId);
  Future<List<PlanterCheckIn>> fetchPlanterCheckIns(String planterId, int month, int year, String token);
  Future<PlanterCheckIn> logPlanterCheckIn(String planterId, PlanterCheckIn checkIn);
  Future<List<PlanterNotification>> fetchPlanterNotifications(String planterId);

  /// Search Requests
  Future<SearchResults> searchActivities({String keyword, int limit});

  /// Activities Requests
  Future<List<Activity>> fetchActivities({String sortedBy, int limit});
  Future<Activity> fetchActivity(String activityId);

  /// Membership
  Future<LoginResponse> login(String username, String password);
  Future<String> signUp(String username, String password);
  Future<String> inviteFriend(String email, String name, String comment);

  /// Messages
  Future<List<Chat>> fetchAllGroups(String planterId);
  Future<List<Message>> fetchGroupMessages(String planterId, String messageGroupId);
  Future<Message> sendMessageToGroup(Message message, String planterId, String messageGroupId);
}
