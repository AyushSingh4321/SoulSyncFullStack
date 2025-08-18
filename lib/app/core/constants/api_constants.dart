class ApiConstants {
  // static const String baseUrl = 'http://localhost:8080/api';
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String sendOtp = '$baseUrl/auth/sendotp';
  static const String validateOtp = '$baseUrl/auth/validateotp';
  
  // User endpoints
  static const String myProfile = '$baseUrl/user/myProfile';
  static const String updateProfile = '$baseUrl/user/updateUserProfile';
  static const String discover = '$baseUrl/user/discover';
  static const String like = '$baseUrl/user/like';
  static const String liked = '$baseUrl/user/liked';
  static const String disableUser = '$baseUrl/user/disableUser';
  static const String reportUser = '$baseUrl/user/reportUser';
  static const String search = '$baseUrl/user/search';
  
  // Date request endpoints
  static const String sendDateRequest = '$baseUrl/dateRequest/send';
  static const String respondToRequest = '$baseUrl/dateRequest';
  static const String editRequest = '$baseUrl/dateRequest';
  static const String allRequests = '$baseUrl/dateRequest/allRequests';
  
  // Chat endpoints
  static const String messages = '$baseUrl/messages';
  static const String wsUrl = 'ws://localhost:8080/ws';
}