// import 'package:cripto_moedas/pages/home_page.dart';
import 'package:cripto_moedas/pages/home_page.dart';
import 'package:cripto_moedas/pages/login_page.dart';
import 'package:cripto_moedas/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeuAplicativo extends StatefulWidget {
  const MeuAplicativo({Key? key}) : super(key: key);

  @override
  State<MeuAplicativo> createState() => _MeuAplicativoState();
}

class _MeuAplicativoState extends State<MeuAplicativo> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  checkAuth() {
    final auth = context.watch<AuthService>();
    if (_navigator.currentState != null) {
      if (auth.usuario == null) {
        _navigator.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      } else if (auth.usuario != null) {
        _navigator.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      } else {
        _navigator.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      }
    }
  }

  // static TransitionBuilder builder(BuildContext context, Widget? child) {
  //       if (child == null) {
  //         throw FlutterError.fromParts([
  //           ErrorSummary('No Navigator or Router provided.'),
  //           ErrorSpacer(),
  //           ErrorDescription(
  //             'Did you include a home Widget or provide routes to your MaterialApp?',
  //           ),
  //           ErrorSpacer(),
  //         ]);
  //       }
  //     }

  @override
  Widget build(BuildContext context) {
    // checkAuth();
    return MaterialApp(
      title: 'Cripto Moedas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      navigatorKey: _navigator,
      home: const HomePage(),
      builder: (context, child) {
        if (child == null) {
          throw FlutterError.fromParts([
            ErrorSummary('No Navigator or Router provided.'),
            ErrorSpacer(),
            ErrorDescription(
              'Did you include a home Widget or provide routes to your MaterialApp?',
            ),
            ErrorSpacer(),
          ]);
        }
        final auth = context.watch<AuthService>();
        return Navigator(
          onPopPage: (_, dynamic __) => true,
          pages: [
            MaterialPage<void>(
              child: ScaffoldMessenger(
                child: (auth.isLoading)
                    ? const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (auth.usuario != null)
                        ? child
                        : const LoginPage(),
              ),
            ),
          ],
        );
      },

      // initialRoute: '/loading',
      // routes: <String, WidgetBuilder>{
      //   '/loading': (context) => const Scaffold(
      //         body: Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       ),
      //   '/home': (context) => const HomePage(),
      //   '/login': (context) => const LoginPage(),
      // },
    );
  }
}
