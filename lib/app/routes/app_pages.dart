import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/aturan_permainan/bindings/aturan_permainan_binding.dart';
import '../modules/aturan_permainan/views/aturan_permainan_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/deteksi/bindings/deteksi_binding.dart';
import '../modules/deteksi/views/deteksi_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/jenis_permainan/bindings/jenis_permainan_binding.dart';
import '../modules/jenis_permainan/views/jenis_permainan_view.dart';
import '../modules/kamus_biliard/bindings/kamus_biliard_binding.dart';
import '../modules/kamus_biliard/views/kamus_biliard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/peralatan/bindings/peralatan_binding.dart';
import '../modules/peralatan/views/peralatan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/teknik_pukulan/bindings/teknik_pukulan_binding.dart';
import '../modules/teknik_pukulan/views/teknik_pukulan_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ON_BOARDING;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: '/kamus-biliard',
      page: () => const KamusBiliardView(),
      binding: KamusBiliardBinding(),
    ),
    GetPage(
      name: '/teknik_pukulan',
      page: () => const TeknikPukulanView(),
      binding: TeknikPukulanBinding(),
    ),
    GetPage(
      name: '/peralatan',
      page: () => const PeralatanView(),
      binding: PeralatanBinding(),
    ),
    GetPage(
      name: '/aturan_permainan',
      page: () => const AturanPermainanView(),
      binding: AturanPermainanBinding(),
    ),
    GetPage(
      name: '/jenis_permainan',
      page: () => const JenisPermainanView(),
      binding: JenisPermainanBinding(),
    ),
    GetPage(
      name: '/deteksi',
      page: () => const DeteksiView(),
      binding: DeteksiBinding(),
    ),
    GetPage(
      name: '/riwayat',
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: '/otp',
      page: () => OtpView(),
      binding: OtpBinding(),
    ),
  ];
}
