part of './app_pages.dart';

abstract class Routes {
  static const initial = '/';
  static const home = '/home';
  static const invalidAccess = '/invalid-access';

  // Auth routes
  static const signIn = "/sign-in";
  static const signUp = "/sign-up";
  static const signUpClient = "/sign-up-client-profile";
  static const signUpProfessional = "/sign-up-professional-profile";
  static const forgotPassword = '/forgot-password';

  // Profile routes
  static const profile = "/profile";
  static const profileProfessional = "/profile-professional";
  static const editProfessional = "/edit-professional";
  static const profileClient = "/profile-client";
  static const editClient = "/edit-client";

  // Announces routes
  static const announceRequest = '/announce-requests';
  static const myRequests = "/my-requests"; // Client requests list
  static const myServices = "/my-services"; // Professional services list to approve/recuse

  // Chat routes
  static const chat = "/chat";
  static const chatDetails = "/chat-details";

  // Saved routes
  static const saveds = "/saveds";

  // Saved routes
  static const educativeContent = "/educative-content";

  // Financeiro routes
  static const finance = "/finance";

  // General routes
  static const settings = '/settings';
  static const about = '/about';
}
