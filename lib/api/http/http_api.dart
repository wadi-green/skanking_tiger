import 'package:dio_http_cache/dio_http_cache.dart';

import '../../data/activity/activity.dart';
import '../../data/activity/planter_activity.dart';
import '../../data/bug.dart';
import '../../data/chat.dart';
import '../../data/login_response.dart';
import '../../data/message.dart';
import '../../data/plant.dart';
import '../../data/planter.dart';
import '../../data/planter_canvas.dart';
import '../../data/planter_checkin.dart';
import '../../data/planter_friend.dart';
import '../../data/planter_notification.dart';
import '../../data/search_results.dart';
import '../api.dart';
import '../api_exceptions.dart';
import 'http_client.dart';

/// The actual [Api] responsible for communicating with the server.
/// In case of an [Exception], it's rethrown to be handled by the UI
class HttpApi implements Api {
  @override
  Future<List<Plant>> fetchPlants(
      {String sortedBy, int limit, List<String> ids}) async {
    final response = await basicClient().get(
      'plants',
      queryParameters: {
        if (sortedBy != null) 'sortedBy': sortedBy,
        if (limit != null) 'limit': limit,
        if (ids != null) 'ids': ids,
      },
    );
    try {
      checkErrors(response);
      final plants = (response.data as List)
          .map((e) => Plant.fromJson(e as Map<String, dynamic>))
          .toList();
      return plants;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Plant> fetchPlant(String plantId) async {
    final response = await basicClient().get('plants/$plantId');
    try {
      checkErrors(response);
      return Plant.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Planter>> fetchPlanters(
      {String sortedBy, int limit, List<String> ids}) async {
    final response = await basicClient().get(
      '/public/api/v1/planters',
      queryParameters: {
        if (sortedBy != null) 'sortedBy': sortedBy,
        if (limit != null) 'limit': limit,
        if (ids != null) 'ids': ids,
      },
    );
    try {
      checkErrors(response);
      final planters = (response.data as List)
          .map((e) => Planter.fromJson(e as Map<String, dynamic>))
          .toList();
      return planters;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Planter> fetchPlanter(String planterId) async {
    final response =
        await basicClient().get('/public/api/v1/planters/$planterId');
    try {
      checkErrors(response);
      return Planter.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanterCanvas> fetchPlanterCanvas(String planterId) async {
    final response = await basicClient()
        .get('/public/api/v1/planters/$planterId/planterCanvas');
    try {
      checkErrors(response);
      return PlanterCanvas.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SearchResults> searchActivities({String keyword, int limit}) async {
    // Search results are cached for improved user experience
    final response = await cachedClient().get(
      '/public/api/v1/search',
      queryParameters: {
        if (keyword != null) 'query': keyword,
        if (limit != null) 'limit': limit,
      },
      options: buildCacheOptions(const Duration(hours: 1)),
    );
    try {
      checkErrors(response);
      return SearchResults.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Activity>> fetchActivities(
      {String sortedBy, int limit, String keyword}) async {
    final response = await basicClient().get(
      '/public/api/v1/activities',
      queryParameters: {
        if (sortedBy != null) 'sortedBy': sortedBy,
        if (limit != null) 'limit': limit,
        if (keyword != null) 'keyword': keyword,
      },
    );
    try {
      checkErrors(response);
      final activities = (response.data as List)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Activity> fetchActivity(String activityId) async {
    final response =
        await basicClient().get('/public/api/v1/activities/$activityId');
    try {
      checkErrors(response);
      return Activity.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanterActivity>> fetchPlanterActivities(String planterId) async {
    final response = await basicClient()
        .get('/public/api/v1/planters/$planterId/activities');
    try {
      checkErrors(response);
      final activities = (response.data as List)
          .map((e) => PlanterActivity.fromJson(e as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanterActivity> fetchPlanterActivity(
      String planterId, String activityId, String token) async {
    final response = await authenticatedClient(token).get(
      '/secured/api/v1/planters/$planterId/activities/$activityId',
    );
    try {
      checkErrors(response);
      return PlanterActivity.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanterNotification>> fetchPlanterNotifications(
      String planterId, String token) async {
    final response = await authenticatedClient(token)
        .get('/secured/api/v1/planters/$planterId/notifications');
    try {
      checkErrors(response);
      return (response.data as List)
          .map((e) => PlanterNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanterCheckIn>> fetchPlanterCheckIns(
      String planterId, int month, int year, String token) async {
    // todo somehow get this token here for the call
    final response = await authenticatedClient(token).get(
      '/secured/api/v1/planters/$planterId/checkins',
      queryParameters: {'date': '$month/$year'},
      options: buildCacheOptions(const Duration(minutes: 30)),
    );
    try {
      checkErrors(response);
      final checkIns = (response.data as List)
          .map((e) => PlanterCheckIn.fromJson(e as Map<String, dynamic>))
          .toList();
      return checkIns;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlanterFriend>> fetchPlanterFriends(String planterId) async {
    final response =
        await basicClient().get('/public/api/v1/planters/$planterId/friends');
    try {
      checkErrors(response);
      final friends = (response.data as List)
          .map((e) => PlanterFriend.fromJson(e as Map<String, dynamic>))
          .toList();
      return friends;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Activity> likeActivity(
      String planterId, String activityId, String token) async {
    final response = await authenticatedClient(token).post(
        '/secured/api/v1/planters/$planterId/activities/$activityId/like');
    try {
      checkErrors(response);
      return Activity.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Bug> fileBug(Bug bug) async {
    final response = await basicClient().post('/public/api/v1/feedback/report');
    try {
      checkErrors(response);
      return Bug.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlanterCheckIn> logPlanterCheckIn(
      String planterId, PlanterCheckIn checkIn, String token) async {
    final response = await authenticatedClient(token).post(
      '/secured/api/v1/planters/$planterId/checkins',
      data: checkIn.toJson(),
    );
    try {
      checkErrors(response);
      return PlanterCheckIn.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Planter> updatePlanter(
      String planterId, Planter planter, String token) async {
    final response = await authenticatedClient(token).put(
      '/secured/api/v1/planters/$planterId',
      data: planter.toJson(),
    );
    try {
      checkErrors(response);
      return Planter.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> inviteFriend(String email, String name, String comment) async {
    final response = await basicClient().post(
      '/public/api/v1/planters/management/invite',
      data: {
        'email': email,
        'name': name,
        'invitationComment': comment,
      },
    );
    try {
      checkErrors(response);
      if (response.data['isInvitationSent'] as bool) {
        return response.data['signupLink'] as String;
      } else {
        throw const ApiException(
          message: 'Could not send invitation! Please retry',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse> login(String username, String password) async {
    final response = await basicClient().post(
      '/public/api/v1/planters/management/login',
      data: {'userName': username, 'password': password},
    );
    try {
      checkErrors(response);
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> signUp(String username, String password) async {
    final response = await basicClient().post(
      'signup',
      data: {'userName': username, 'password': password},
    );
    try {
      checkErrors(response);
      if (response.data['isSuccessful'] as bool) {
        return response.data['signupLink'] as String;
      } else {
        throw const ApiException(message: 'Sign up failed! Please retry');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Message>> fetchGroupMessages(
      String planterId, String messageGroupId) async {
    final response = await authenticatedClient('').get(
      'planters/$planterId/chatGroups/$messageGroupId',
    );
    try {
      checkErrors(response);
      return (response.data as List ?? [])
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Message> sendMessageToGroup(
      Message message, String planterId, String messageGroupId) async {
    final response = await authenticatedClient('').post(
      'planters/$planterId/chatGroups/$messageGroupId',
      data: message.toJson(),
    );
    try {
      checkErrors(response);
      return Message.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Chat>> fetchAllGroups(String planterId) async {
    final response = await authenticatedClient('').get(
      'planters/$planterId/chatGroups',
    );
    try {
      checkErrors(response);
      return (response.data as List ?? [])
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
