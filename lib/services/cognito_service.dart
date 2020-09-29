import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cognito_storage.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

// final credentials = new CognitoCredentials('us-east-2:de074c4c-2e6d-456d-84b6-b11bc7fa2eb6', userPool);

class CognitoService {
  final CognitoUserPool _userPool = new CognitoUserPool('us-east-2_FFPmb68u4', '3gc6oft576ol7ad0sf741n5jtg');
  
  CognitoUser _user;
  CognitoUserSession session;
  CognitoCredentials credentials;
  CognitoService();

  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = new Storage(prefs);
    _userPool.storage = storage;

    _user = await _userPool.getCurrentUser();
    if (_user == null) {
      return false;
    }
    session = await _user.getSession();
    return session.isValid();
  }

  Future<bool> signUpUser(String username, String password, List<AttributeArg> userAttributes) async {
    bool succeed;
    var data;
    try {
      data = await _userPool.signUp(username, password, userAttributes: userAttributes);
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }
    print(data);
    return succeed;
  }

  Future<bool> confirmUser(String username, String code) async {
    _user= new CognitoUser(username, _userPool, storage: _userPool.storage);
    bool registerConfirmed = false;
    try {
      registerConfirmed = await _user.confirmRegistration(code);
    } catch (e) {
      print(e);
    }
    return registerConfirmed;
  }

  Future<bool> resendCode(String username) async {
    _user = new CognitoUser(username, _userPool, storage: _userPool.storage);
    bool succeed;
    String status;
    try {
      status = await _user.resendConfirmationCode();
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }
    return succeed;
  }

  Future<bool> signInUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    _user = new CognitoUser(username, _userPool, storage: _userPool.storage);
    final authDetails = new AuthenticationDetails(username: username, password: password);
    bool succeed;
    try {
      session = await _user.authenticateUser(authDetails);
      succeed = true;
      prefs.setString('user', username);
    } catch (e) {
      print(e);
      succeed = false;
    }
    return succeed;
  }

  Future<bool> verifyEmail(String email, String code) async {
    _user = new CognitoUser(email, _userPool, storage: _userPool.storage);
    var data;
    try {
      data = await _user.getAttributeVerificationCode(email);
    } catch (e) {
      print(e);
    }
    bool attributeVerified = false;
    try {
      attributeVerified = await _user.verifyAttribute(
          email, code);
    } catch (e) {
      print(e);
    }
    return attributeVerified;
  }


  Future<bool> forgotPassword(String username) async {
    final cognitoUser = new CognitoUser(username, _userPool, storage: _userPool.storage);
    bool succeed;
    var data;
    try {
      data = await cognitoUser.forgotPassword();
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }
    print('Code sent to $data');
    return succeed;
  }


  Future<bool> checkAuthenticated() async {
    if (_user == null || session == null) {
      return false;
    }
    return session.isValid();
  }

  Future<bool> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    bool succeed = false;
    if (credentials != null) {
      await credentials.resetAwsCredentials();
      succeed = true;
      prefs.remove('user');
    }
    if (_user != null) {
      await _user.signOut();
      succeed = true;
      prefs.remove('user');
    }
    return succeed;
  }

  Future<bool> changePassword(String username, String code, String newPassword) async {
    _user = new CognitoUser(username, _userPool, storage: _userPool.storage);
    bool passwordConfirmed = false;
    try {
      passwordConfirmed = await _user.confirmPassword(
          code, newPassword);
    } catch (e) {
      print(e);
    }
    return passwordConfirmed;
  }

  Future<String> getToken() async {
    _user = await _userPool.getCurrentUser();
    session = await _user.getSession();
    return session.getIdToken().getJwtToken();
  }

}







