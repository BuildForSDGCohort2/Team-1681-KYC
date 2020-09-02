import 'package:mdcash/API/data_api.dart';
import 'package:mdcash/models/api_response.dart';
import 'package:mdcash/models/command.dart';
import 'package:mdcash/models/line.dart';
import 'package:mdcash/models/operator.dart';
import 'package:mdcash/models/role.dart';
import 'package:mdcash/models/trans_effect.dart';
import 'package:mdcash/models/transaction.dart';
import 'package:mdcash/models/user.dart';

abstract class DataRepository {
  // User
  Future<Map<String, dynamic>> login(Map<String, dynamic> userData);
  Future<Map<String, dynamic>> addUser(User user);
  Future<Map<String, dynamic>> resetPassword(
      User user, Map<String, dynamic> userData);
  Future<Map<String, dynamic>> fetchUsers(String level);

  Future<Map<String, dynamic>> getActions(String userRole, String operatorId);
  Future<Map<String, dynamic>> addUserInfo(Map<String, dynamic> userData);

  // Notifictions
  Future<Map<String, dynamic>> fetchNotifications(int userid);
  Future<Map<String, dynamic>> changeReadStatus(int notificationId);

  // Transactions
  Future<Map<String, dynamic>> fetchTransactions(int userid);
  Future<Map<String, dynamic>> fetchTransaction(int transactionId);
  Future<Map<String, dynamic>> addTransaction(
      int userid, Transaction transaction);

  // Roles
  Future<Map<String, dynamic>> fetchRoles();
  Future<Map<String, dynamic>> fetchRole(int roleId);
  Future<Map<String, dynamic>> addRole(Role role);
  Future<Map<String, dynamic>> deleteRole(int roleId);
  Future<Map<String, dynamic>> updateRole(int roleId, Role role);

  // Transaction Effects
  Future<Map<String, dynamic>> fetchEffects();
  Future<Map<String, dynamic>> fetchEffect(int effectId);
  Future<Map<String, dynamic>> addEffect(Effect effect);
  Future<Map<String, dynamic>> deleteEffect(int effectId);
  Future<Map<String, dynamic>> updateEffect(int effectId, Effect effect);
  Future<Map<String, dynamic>> verifyPin(int userid, String pin);

  // Operators
  Future<Map<String, dynamic>> fetchOperators();
  Future<Map<String, dynamic>> fetchOperator(int operatorId);
  Future<Map<String, dynamic>> addOperator(Operator mobileOperator);
  Future<Map<String, dynamic>> deleteOperator(int operatorId);
  Future<Map<String, dynamic>> updateOperator(
      int operatorId, Operator selectedOperator);

  // Commands
  Future<Map<String, dynamic>> fetchCommands();
  Future<Map<String, dynamic>> fetchCommand(int commandId);
  Future<Map<String, dynamic>> addCommand(Command mobileCommand);
  Future<Map<String, dynamic>> updateCommand(
      int commandId, Command selectedCommand);
  Future<Map<String, dynamic>> deleteCommand(int commandId);

  // Lines
  Future<Map<String, dynamic>> fetchLines();
  Future<Map<String, dynamic>> fetchLine(int lineId);
  Future<Map<String, dynamic>> addLine(Line mobileLine);
  Future<Map<String, dynamic>> updateLine(int lineId, Line line);
  Future<Map<String, dynamic>> deleteLine(int lineId);
}

class EMEDataRepository implements DataRepository {
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
  Future<Map<String, dynamic>> addUser(User user) async {
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

  // User actions
  @override
  Future<Map<String, dynamic>> getActions(
      String userRole, String operatorId) async {
    final response = await api.getUserActions(userRole, operatorId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
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
  @override
  Future<Map<String, dynamic>> addRole(Role mobileRole) async {
    final APIResponse response = await api.addRole(mobileRole);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRole(int roleId) async {
    final APIResponse response = await api.getRole(roleId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRoles() async {
    final APIResponse response = await api.getRoles();
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRole(int roleId) async {
    final APIResponse response = await api.deleteRole(roleId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> updateRole(int roleId, Role role) async {
    final APIResponse response = await api.editRole(roleId, role);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Transaction Effects
  @override
  Future<Map<String, dynamic>> addEffect(Effect mobileEffect) async {
    final APIResponse response = await api.addEffect(mobileEffect);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchEffect(int effectId) async {
    final APIResponse response = await api.getEffect(effectId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchEffects() async {
    final APIResponse response = await api.getEffects();
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteEffect(int effectId) async {
    final APIResponse response = await api.deleteEffect(effectId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> updateEffect(int effectId, Effect effect) async {
    final APIResponse response = await api.editEffect(effectId, effect);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> verifyPin(int userid, String pin) async {
    final APIResponse response = await api.verifyUserPin(userid, pin);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Operator
  @override
  Future<Map<String, dynamic>> addOperator(Operator mobileOperator) async {
    final APIResponse response = await api.addOperator(mobileOperator);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchOperator(int operatorId) async {
    final APIResponse response = await api.getOperator(operatorId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchOperators() async {
    final APIResponse response = await api.getOperators();
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> updateOperator(
      int operatorId, Operator selectedOperator) async {
    final APIResponse response =
        await api.editOperator(operatorId, selectedOperator);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteOperator(int operatorId) async {
    final APIResponse response = await api.deleteOperator(operatorId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Transactions
  @override
  Future<Map<String, dynamic>> addTransaction(
      int userid, Transaction mobileTransaction) async {
    final APIResponse response =
        await api.addTransaction(userid, mobileTransaction);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchTransaction(int transactionId) async {
    final APIResponse response = await api.getTransaction(transactionId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchTransactions(int userid) async {
    final APIResponse response = await api.getTransactions(userid);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Commands
  @override
  Future<Map<String, dynamic>> addCommand(Command mobileCommand) async {
    final APIResponse response = await api.addCommand(mobileCommand);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCommand(int commandId) async {
    final APIResponse response = await api.getCommand(commandId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCommands() async {
    final APIResponse response = await api.getCommands();
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> updateCommand(
      int commandId, Command selectedCommand) async {
    final APIResponse response =
        await api.editCommand(commandId, selectedCommand);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteCommand(int commandId) async {
    final APIResponse response = await api.deleteCommand(commandId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  // Mobile Lines
  @override
  Future<Map<String, dynamic>> addLine(Line mobileLine) async {
    final APIResponse response = await api.addLine(mobileLine);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchLine(int lineId) async {
    final APIResponse response = await api.getLine(lineId);
    if (response.error) {
      return {
        'error': response.errorMessage,
      };
    } else {
      return {
        'data': response.data,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchLines() async {
    final APIResponse response = await api.getLines();
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> updateLine(int lineId, Line selectedLine) async {
    final APIResponse response = await api.editLine(lineId, selectedLine);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteLine(int lineId) async {
    final APIResponse response = await api.deleteLine(lineId);
    if (response.error) {
      return {'error': response.errorMessage};
    } else {
      return {'data': response.data};
    }
  }
}
