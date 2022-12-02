import './routes.dart';
part './app_routes.dart';

class AppPages {
  static final routes = [
    /// Initial Pages
    GetPage(
        name: Routes.initial,
        page: () => const SplashPage(),
        binding: SplashBinding()),

    /// Auth Pages
    GetPage(
        name: Routes.signIn,
        page: () => SignInPage(),
        binding: SignInBinding()),
    GetPage(
        name: Routes.signUp,
        page: () => SignUpPage(),
        binding: SignUpBinding()),
    GetPage(
        name: Routes.signUpClient,
        page: () => SignUpClientPage(),
        binding: SignUpBinding()),
    GetPage(
        name: Routes.signUpProfessional,
        page: () => SignUpProfessionalPage(),
        binding: SignUpBinding()),
    GetPage(
      name: Routes.forgotPassword,
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBinding()),

    /// Home Pages
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    /// Chat Pages
    GetPage(
      name: Routes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.chatDetails,
      page: () => const ChatDetailsPage(),
      binding: ChatBinding(),
    ),

    /// Requests Pages
    GetPage(
      name: Routes.myRequests,
      page: () => const MyRequestsPage(),
      binding: AnnounceBinding(),
    ),

    /// Services Pages
    GetPage(
      name: Routes.myServices,
      page: () => const MyServicesPage(),
      binding: AnnounceBinding(),
    ),

    /// Profiles Page
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    // Professional
    GetPage(
      name: Routes.profileProfessional,
      page: () => const ProfessionalDetailsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.editProfessional,
      page: () => EditProfessionalPage(),
      binding: EditProfileBinding(),
    ),
    // Client
    GetPage(
      name: Routes.profileClient,
      page: () => ClientDetailsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.editClient,
      page: () => EditClientPage(),
      binding: EditProfileBinding(),
    ),

    /// Saveds Pages
    GetPage(
      name: Routes.saveds,
      page: () => const SavedsPage(),
      binding: SavedsBinding(),
    ),

    /// General Pages
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding()
    ),
  ];
}
