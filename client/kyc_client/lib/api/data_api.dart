import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kyc_client/models/api_response.dart';
import 'package:kyc_client/models/notification.dart';
import 'package:kyc_client/models/user.dart';

class DataAPI {
  int operatorIndex;
  int lineIndex;
  int agentIndex;
  int roleIndex;
  int commandIndex;
  int faqIndex;
  // String port = '5800';

  User _authenticatedUser;
  final String url = 'http://10.0.2.2:5800';
  // final String url = 'http://192.168.0.50:5800';
  // Login User

  // Future<Map<String, dynamic>> login(Map<String, String> formData) async {
  //   final Map<String, dynamic> loginResponse = await api.login(formData);
  //   return loginResponse;
  // }

  Future<Map<String, dynamic>> login(Map<String, String> formData) async {
    final response = await http.post(
      '$url/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    final Map<String, dynamic> parsedResponse = json.decode(response.body);
    bool hasError = true;
    String message = 'Something Went Wrong!';
    if (parsedResponse.containsKey('reset_token')) {
      hasError = false;
      message = 'Authentication succeeded';
      _authenticatedUser = User(
        id: parsedResponse['userId'],
        phone: formData['phone'],
        avartar: parsedResponse['avartar'],
        lastname: parsedResponse['lastname'],
        firstname: parsedResponse['firstname'],
        email: parsedResponse['email'],
      );
    } else if (parsedResponse.containsKey('token')) {
      hasError = false;
      message = 'Authentication Succeeded!';
      _authenticatedUser = User(
        id: parsedResponse['userId'],
        token: parsedResponse['token'],
        phone: formData['phone'],
        firstname: parsedResponse['firstname'],
        lastname: parsedResponse['lastname'],
        email: parsedResponse['email'],
        avartar: parsedResponse['avartar'],
      );
    } else {
      message = parsedResponse['message'];
    }
    return {
      'success': !hasError,
      'message': message,
      'user': _authenticatedUser
    };
  }

  // Create User
  Future<APIResponse<bool>> createUser(User user) async {
    final Map<String, dynamic> formData = user.toJson();
    final response = await http.post(
      '$url/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Update User Information
  Future<APIResponse<User>> updateUserInfo(
      Map<String, dynamic> userData) async {
    final response = await http.put(
      '$url/profile/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      User updatedUser;
      final Map<String, dynamic> result = parsedResponse['data'];

      updatedUser = User.fromJson(result);
      return APIResponse<User>(data: updatedUser);
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Reset Password
  Future<APIResponse<bool>> resetPassword(
      User user, Map<String, dynamic> formData) async {
    final response = await http.post(
      '$url/reset_password/${user.token}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<List<User>>> getUsers(String level) async {
    List<User> users = [];

    final response = await http.get('$url/users/$level');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];
      results.forEach((result) => users.add(User.fromJson(result)));

      return APIResponse<List<User>>(
        data: users,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  // User Notifications
  Future<APIResponse<List<UserNotification>>> getNotifications(
      int userid) async {
    List<UserNotification> notifications = [];

    final response = await http.get('$url/notifications/$userid');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach(
          (result) => notifications.add(UserNotification.fromJson(result)));

      return APIResponse<List<UserNotification>>(
        data: notifications,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> changeReadStatus(int notificationId) async {
    final response = await http.post(
      '$url/notifications',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'notification_id': notificationId.toString()}),
    );
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Future<APIResponse<bool>> addRole(Role newRole) async {
  //   final Map<String, dynamic> formData = newRole.toJson();
  //   final response = await http.post(
  //     '$url/roles',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(formData),
  //   );
  //   final parsedResponse = jsonDecode(response.body);

  //   if (parsedResponse['status'] == 'success') {
  //     return APIResponse<bool>(data: true);
  //   } else {
  //     return APIResponse<bool>(
  //         error: true, errorMessage: parsedResponse['message']);
  //   }
  // }

  // Future<APIResponse<Role>> getRole(int roleId) async {
  //   final response = await http.get('$url/roles/$roleId');
  //   final parsedResponse = json.decode(response.body);
  //   if (parsedResponse['status'] == 'success') {
  //     Role fetchedRole;
  //     final Map<String, dynamic> result = parsedResponse['data'];

  //     fetchedRole = Role.fromJson(result);

  //     return APIResponse<Role>(
  //       data: fetchedRole,
  //     );
  //   } else {
  //     return APIResponse(error: true, errorMessage: parsedResponse['message']);
  //   }
  // }

  // Future<APIResponse<bool>> editRole(int roleId, Role fetchedRole) async {
  //   final Map<String, dynamic> formData = fetchedRole.toJson();
  //   final response = await http.put(
  //     '$url/role/$roleId/update',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(formData),
  //   );
  //   final parsedResponse = jsonDecode(response.body);

  //   if (parsedResponse['status'] == 'success') {
  //     return APIResponse<bool>(data: true);
  //   } else {
  //     return APIResponse<bool>(
  //         error: true, errorMessage: parsedResponse['message']);
  //   }
  // }

  // Future<APIResponse<bool>> deleteRole(int roleId) async {
  //   final response = await http.delete('$url/role/$roleId/delete');
  //   final parsedResponse = jsonDecode(response.body);

  //   if (parsedResponse['status'] == 'success') {
  //     return APIResponse<bool>(data: true);
  //   } else {
  //     return APIResponse<bool>(
  //         error: true, errorMessage: parsedResponse['message']);
  //   }
  // }

}
