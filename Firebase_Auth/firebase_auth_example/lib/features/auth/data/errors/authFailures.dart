import 'package:firebase_auth_example/core/errors/failures.dart';

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message: message);

  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return const AuthFailure(
          'Email already used. Go to login page.',
        );

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return const AuthFailure(
          "Wrong email/password combination.",
        );

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return const AuthFailure(
          "No user found with this email.",
        );

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return const AuthFailure(
          "User disabled.",
        );

      case "ERROR_TOO_MANY_REQUESTS":
        return const AuthFailure(
          "Too many requests. Try again later.",
        );

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return const AuthFailure(
          "Operation not allowed. Please contact support.",
        );

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return const AuthFailure(
          "Email address is invalid.",
        );

      default:
        return const AuthFailure(
          "Authentication failed. Please try again.",
        );
    }
  }
}
