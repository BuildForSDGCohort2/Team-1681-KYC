import 'package:kyc_client/api/data_api.dart';
import 'package:kyc_client/models/api_response.dart';
import 'package:kyc_client/models/user.dart';

abstract class DataRepository {
  // User
  Future<Map<String, dynamic>> login(Map<String, dynamic> userData);
  Future<Map<String, dynamic>> registerUser(User user);
  Future<Map<String, dynamic>> resetPassword(
      User user, Map<String, dynamic> userData);
  Future<Map<String, dynamic>> fetchUsers(String level);

  // Future<Map<String, dynamic>> getActions(String userRole, String operatorId);
  // Future<Map<String, dynamic>> addUserInfo(Map<String, dynamic> userData);

  // Notifictions
  Future<Map<String, dynamic>> fetchNotifications(int userid);
  Future<Map<String, dynamic>> changeReadStatus(int notificationId);
}

class KYCDataRepository implements DataRepository {
  DataAPI api = DataAPI();

  // Authentication
  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> userData) async {
    final response = await api.login(userData);
    if (!response['success']) {
      return {'error': response['message']};
    } else {
      return {'data': response};
    }
  }

  @override
  Future<Map<String, dynamic>> registerUser(User user) async {
    final APIResponse response = await api.createUser(user);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> addUserInfo(
      Map<String, dynamic> userData) async {
    final APIResponse response = await api.updateUserInfo(userData);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      User user, Map<String, dynamic> userData) async {
    final APIResponse response = await api.resetPassword(user, userData);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Fetch Users
  @override
  Future<Map<String, dynamic>> fetchUsers(String level) async {
    final APIResponse response = await api.getUsers(level);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Notifications
  @override
  Future<Map<String, dynamic>> fetchNotifications(int userid) async {
    final APIResponse response = await api.getNotifications(userid);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> changeReadStatus(int notificationId) async {
    final APIResponse response = await api.changeReadStatus(notificationId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Roles
  // @override
  // Future<Map<String, dynamic>> addRole(Role mobileRole) async {
  //   final APIResponse response = await api.addRole(mobileRole);
  //   if (response.error) {
  //     return {
  //       'error': response.errorMessage,
  //     };
  //   } else {
  //     return {
  //       'data': response.data,
  //     };
  //   }
  // }

  // @override
  // Future<Map<String, dynamic>> fetchRole(int roleId) async {
  //   final APIResponse response = await api.getRole(roleId);
  //   if (response.error) {
  //     return {
  //       'error': response.errorMessage,
  //     };
  //   } else {
  //     return {
  //       'data': response.data,
  //     };
  //   }
  // }

  // @override
  // Future<Map<String, dynamic>> fetchRoles() async {
  //   final APIResponse response = await api.getRoles();
  //   if (response.error) {
  //     return {'error': response.errorMessage};
  //   } else {
  //     return {'data': response.data};
  //   }
  // }

  // @override
  // Future<Map<String, dynamic>> deleteRole(int roleId) async {
  //   final APIResponse response = await api.deleteRole(roleId);
  //   if (response.error) {
  //     return {'error': response.errorMessage};
  //   } else {
  //     return {'data': response.data};
  //   }
  // }

  // @override
  // Future<Map<String, dynamic>> updateRole(int roleId, Role role) async {
  //   final APIResponse response = await api.editRole(roleId, role);
  //   if (response.error) {
  //     return {'error': response.errorMessage};
  //   } else {
  //     return {'data': response.data};
  //   }
  // }

}
