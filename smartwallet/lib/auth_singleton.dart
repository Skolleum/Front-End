//this singleton will be removed once the authentication flow is decided.
class AuthCheck {
  static AuthCheck instance = AuthCheck._init();
  AuthCheck._init();

  bool isLoggedIn = false;
}

// enum Status {
//   didSignIn,
//   didNotSignIn,
// }
