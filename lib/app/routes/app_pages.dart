import 'package:get/get.dart';
import 'package:soulsync_frontend/app/routes/app_routes.dart';
import 'package:soulsync_frontend/app/modules/splash/bindings/splash_binding.dart';
import 'package:soulsync_frontend/app/modules/splash/views/splash_view.dart';
import 'package:soulsync_frontend/app/modules/auth/bindings/auth_binding.dart';
import 'package:soulsync_frontend/app/modules/auth/views/auth_view.dart';
import 'package:soulsync_frontend/app/modules/home/bindings/home_binding.dart';
import 'package:soulsync_frontend/app/modules/home/views/home_view.dart';
import 'package:soulsync_frontend/app/modules/profile/bindings/profile_binding.dart';
import 'package:soulsync_frontend/app/modules/profile/views/profile_view.dart';
import 'package:soulsync_frontend/app/modules/profile/views/edit_profile_view.dart';
import 'package:soulsync_frontend/app/modules/user_details/bindings/user_details_binding.dart';
import 'package:soulsync_frontend/app/modules/user_details/views/user_details_view.dart';
import 'package:soulsync_frontend/app/modules/chat/bindings/chat_binding.dart';
import 'package:soulsync_frontend/app/modules/chat/views/chat_view.dart';
import 'package:soulsync_frontend/app/modules/chat/views/chat_room_view.dart';
import 'package:soulsync_frontend/app/modules/liked_users/bindings/liked_users_binding.dart';
import 'package:soulsync_frontend/app/modules/liked_users/views/liked_users_view.dart';
import 'package:soulsync_frontend/app/modules/date_requests/bindings/date_requests_binding.dart';
import 'package:soulsync_frontend/app/modules/date_requests/views/date_requests_view.dart';
import 'package:soulsync_frontend/app/modules/dates/bindings/dates_binding.dart';
import 'package:soulsync_frontend/app/modules/dates/views/dates_view.dart';
import 'package:soulsync_frontend/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:soulsync_frontend/app/modules/notifications/views/notifications_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.userDetails,
      page: () => const UserDetailsView(),
      binding: UserDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.likedUsers,
      page: () => const LikedUsersView(),
      binding: LikedUsersBinding(),
    ),
    GetPage(
      name: AppRoutes.dateRequests,
      page: () => const DateRequestsView(),
      binding: DateRequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.dates,
      page: () => const DatesView(),
      binding: DatesBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}