import 'package:flutter/material.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/features/auth/presentation/views/login_view.dart';
import 'package:propertybooking/features/home/presentation/views/home_view.dart';
import 'package:propertybooking/features/home/presentation/views/land_view.dart';
import 'package:propertybooking/features/home/presentation/views/building_view.dart';
import 'package:propertybooking/features/shared/splash/views/splash_view.dart';
import 'package:propertybooking/features/lead/presentation/views/lead_manager_view.dart';
import 'package:propertybooking/features/lead/presentation/views/sales_tracking_view.dart';
import 'package:propertybooking/features/lead/presentation/views/request_detail_view.dart';
import 'package:propertybooking/features/lead/data/models/salesperson_model.dart';
import 'package:propertybooking/features/lead/data/models/unit_request_model.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/home/data/models/project_model.dart';
import '../../../features/home/data/models/building_model.dart';
import '../../../features/home/data/datasource/home_datasource.dart';

import 'package:propertybooking/features/lead/presentation/views/salesperson_home_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as dynamic;
    switch (settings.name) {
      case RouterPath.splashView:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashView();
          },
        );
      case RouterPath.loginView:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginView();
          },
        );
      case RouterPath.homeView:
        return MaterialPageRoute(
          builder: (context) {
            return HomeView(userModel: arguments as UserModel);
          },
        );
      case RouterPath.landView:
        return MaterialPageRoute(
          builder: (context) {
            final args = arguments as Map<String, dynamic>;
            return LandView(
              project: args['project'] as ProjectModel,
              homeDatasource: args['homeDatasource'] as HomeDatasource,
            );
          },
        );
      case RouterPath.buildingView:
        return MaterialPageRoute(
          builder: (context) {
            return BuildingView(building: arguments as BuildingModel);
          },
        );

      // ── Lead Manager Portal ──────────────────────────────────────────────
      case RouterPath.leadManagerView:
        return MaterialPageRoute(builder: (_) => const LeadManagerView());

      case RouterPath.salesTrackingView:
        return MaterialPageRoute(
          builder: (_) =>
              SalesTrackingView(salesPerson: arguments as SalesPerson),
        );

      case RouterPath.requestDetailView:
        return MaterialPageRoute(
          builder: (_) => RequestDetailView(request: arguments as UnitRequest),
        );

      case RouterPath.salespersonHomeView:
        return MaterialPageRoute(
          builder: (_) =>
              SalespersonHomeView(salesPerson: arguments as SalesPerson),
        );
    }
    return null;
  }

  Route _bottomToTopTransition(Widget page, {required String routeName}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
