import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mdcash/models/api_response.dart';
import 'package:mdcash/models/command.dart';
import 'package:mdcash/models/line.dart';

import 'package:mdcash/models/operator.dart';
import 'package:mdcash/models/role.dart';
import 'package:mdcash/models/trans_effect.dart';
import 'package:mdcash/models/transaction.dart';
import 'package:mdcash/models/user.dart';
import 'package:mdcash/models/user_notification.dart';

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
        resettoken: parsedResponse['reset_token'],
        phone: formData['phone'],
        role: parsedResponse['role'],
        avartar: parsedResponse['avartar'],
      );
    } else if (parsedResponse.containsKey('token')) {
      hasError = false;
      message = 'Authentication Succeeded!';
      _authenticatedUser = User(
        id: parsedResponse['userId'],
        token: parsedResponse['token'],
        phone: formData['phone'],
        role: parsedResponse['role'],
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
      '$url/users/add',
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
      '$url/reset_password/${user.resettoken}',
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

  // Operators
  Future<APIResponse<List<Operator>>> getOperators() async {
    List<Operator> operators = [];

    final response = await http.get('$url/operators');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach((result) => operators.add(Operator.fromJson(result)));

      return APIResponse<List<Operator>>(
        data: operators,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> addOperator(Operator newOperator) async {
    final Map<String, dynamic> formData = newOperator.toJson();
    final response = await http.post(
      '$url/operators',
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

  Future<APIResponse<Operator>> getOperator(int operatorId) async {
    final response = await http.get('$url/operators/$operatorId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Operator fetchedOperator;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedOperator = Operator.fromJson(result);

      return APIResponse<Operator>(
        data: fetchedOperator,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> editOperator(
      int operatorId, Operator fetchedOperator) async {
    final Map<String, dynamic> formData = fetchedOperator.toJson();
    final response = await http.put(
      '$url/operator/$operatorId/update',
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

  Future<APIResponse<bool>> deleteOperator(int operatorId) async {
    final response = await http.delete('$url/operator/$operatorId/delete');
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Lines
  Future<APIResponse<List<Line>>> getLines() async {
    List<Line> lines = [];

    final response = await http.get('$url/lines');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach((result) => lines.add(Line.fromJson(result)));

      return APIResponse<List<Line>>(
        data: lines,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> addLine(Line newLine) async {
    final Map<String, dynamic> formData = newLine.toJson();
    final response = await http.post(
      '$url/lines',
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

  Future<APIResponse<Line>> getLine(int lineId) async {
    final response = await http.get('$url/lines/$lineId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Line fetchedLine;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedLine = Line.fromJson(result);

      return APIResponse<Line>(
        data: fetchedLine,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> editLine(int lineId, Line fetchedLine) async {
    final Map<String, dynamic> formData = fetchedLine.toJson();
    final response = await http.put(
      '$url/lines/$lineId/update',
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

  Future<APIResponse<bool>> deleteLine(int lineId) async {
    final response = await http.delete('$url/line/$lineId/delete');
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Transaction Effects
  Future<APIResponse<List<Effect>>> getEffects() async {
    List<Effect> effects = [];

    final response = await http.get('$url/trans_effects');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach((result) => effects.add(Effect.fromJson(result)));

      return APIResponse<List<Effect>>(
        data: effects,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> addEffect(Effect newEffect) async {
    final Map<String, dynamic> formData = newEffect.toJson();
    final response = await http.post(
      '$url/trans_effects',
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

  Future<APIResponse<Effect>> getEffect(int effectId) async {
    final response = await http.get('$url/trans_effects/$effectId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Effect fetchedEffect;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedEffect = Effect.fromJson(result);

      return APIResponse<Effect>(
        data: fetchedEffect,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> editEffect(
      int effectId, Effect fetchedEffect) async {
    final Map<String, dynamic> formData = fetchedEffect.toJson();
    final response = await http.put(
      '$url/trans_effects/$effectId/update',
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

  Future<APIResponse<bool>> deleteEffect(int effectId) async {
    final response = await http.delete('$url/trans_effect/$effectId/delete');
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Commands

  Future<APIResponse<List<Command>>> getCommands() async {
    List<Command> commands = [];

    final response = await http.get('$url/commands');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach((result) => commands.add(Command.fromJson(result)));

      return APIResponse<List<Command>>(
        data: commands,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> addCommand(Command newCommand) async {
    final Map<String, dynamic> formData = newCommand.toJson();
    final response = await http.post(
      '$url/commands',
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

  Future<APIResponse<List<Command>>> getUserActions(
      String userRole, String operatorId) async {
    List<Command> actions = [];

    final response = await http.post(
      '$url/commands/$userRole',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'operatorId': operatorId}),
    );

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];
      // print('Commands Retrieved: ${parsedResponse['data']}');

      results.forEach((result) => actions.add(Command.fromJson(result)));

      return APIResponse<List<Command>>(
        data: actions,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<Command>> getCommand(int commandId) async {
    final response = await http.get('$url/commands/$commandId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Command fetchedCommand;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedCommand = Command.fromJson(result);

      return APIResponse<Command>(
        data: fetchedCommand,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> editCommand(
      int commandId, Command fetchedCommand) async {
    final Map<String, dynamic> formData = fetchedCommand.toJson();
    final response = await http.put(
      '$url/command/$commandId/update',
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

  Future<APIResponse<bool>> deleteCommand(int commandId) async {
    final response = await http.delete('$url/command/$commandId/delete');
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Roles

  Future<APIResponse<List<Role>>> getRoles() async {
    List<Role> roles = [];

    final response = await http.get('$url/roles');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results.forEach((result) => roles.add(Role.fromJson(result)));

      return APIResponse<List<Role>>(
        data: roles,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> addRole(Role newRole) async {
    final Map<String, dynamic> formData = newRole.toJson();
    final response = await http.post(
      '$url/roles',
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

  Future<APIResponse<Role>> getRole(int roleId) async {
    final response = await http.get('$url/roles/$roleId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Role fetchedRole;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedRole = Role.fromJson(result);

      return APIResponse<Role>(
        data: fetchedRole,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> editRole(int roleId, Role fetchedRole) async {
    final Map<String, dynamic> formData = fetchedRole.toJson();
    final response = await http.put(
      '$url/role/$roleId/update',
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

  Future<APIResponse<bool>> deleteRole(int roleId) async {
    final response = await http.delete('$url/role/$roleId/delete');
    final parsedResponse = jsonDecode(response.body);

    if (parsedResponse['status'] == 'success') {
      return APIResponse<bool>(data: true);
    } else {
      return APIResponse<bool>(
          error: true, errorMessage: parsedResponse['message']);
    }
  }

  // Transactions
  Future<APIResponse<List<Transaction>>> getTransactions(int userid) async {
    List<Transaction> transactions = [];

    final response = await http.get('$url/transactions/$userid');

    final parsedResponse = json.decode(response.body);

    if (parsedResponse['status'] == 'success') {
      final List results = parsedResponse['data'];

      results
          .forEach((result) => transactions.add(Transaction.fromJson(result)));

      return APIResponse<List<Transaction>>(
        data: transactions,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }

  Future<APIResponse<bool>> verifyUserPin(int userid, String userPin) async {
    final Map<String, dynamic> formData = {'userPin': userPin};
    final response = await http.post(
      '$url/transactions/$userid/verifypin',
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

  Future<APIResponse<bool>> addTransaction(
      int userid, Transaction newTransaction) async {
    final Map<String, dynamic> formData = newTransaction.toJson();
    final response = await http.post(
      '$url/transactions/$userid',
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

  Future<APIResponse<Transaction>> getTransaction(int transactionId) async {
    final response = await http.get('$url/transactions/$transactionId');
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == 'success') {
      Transaction fetchedTransaction;
      final Map<String, dynamic> result = parsedResponse['data'];

      fetchedTransaction = Transaction.fromJson(result);

      return APIResponse<Transaction>(
        data: fetchedTransaction,
      );
    } else {
      return APIResponse(error: true, errorMessage: parsedResponse['message']);
    }
  }
}
