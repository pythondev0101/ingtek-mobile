import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ingtek_mobile/global_variables.dart';
import 'package:ingtek_mobile/models/user_model.dart';
import 'package:ingtek_mobile/pages/home_page.dart';
import 'package:ingtek_mobile/pages/login_page.dart';
import 'package:ingtek_mobile/pages/splash_page.dart';
import 'package:ingtek_mobile/services/user_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await connectToDB();
  await SentryFlutter.init(
      (options) {
        options.dsn = 'https://a796419f472d42579dd4761e3acfafac@o4503912449245184.ingest.sentry.io/4503977030254592';
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(const App()),
  );
}

Future<void> connectToDB() async {
  // DEV DB
  // globalMongoDB = await Db.create("mongodb+srv://dbUser:dbUserPassword@cluster0.jjlnnvp.mongodb.net/upecDevDB?retryWrites=true&w=majority&ssl=true");
  // PROD DB
  globalMongoDB = await Db.create("mongodb+srv://dbUser:dbUserPassword@cluster0.jjlnnvp.mongodb.net/upecProdDB?retryWrites=true&w=majority&ssl=true");
  await globalMongoDB!.open();
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  Future<User> getUserData() => UserService.getUser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingtek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home':(context) => const HomePage(),
        '/login':(context) => const LoginPage()
      },
      home: FutureBuilder<User>(
        future: getUserData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const SplashPage();
            default:
              print(snapshot.data?.mongoId);
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (snapshot.data?.mongoId == null) {
                print("go to login");
                return const LoginPage();
              }
              print("go to home");
              globalCurrentUser.value = snapshot.data!;
              return const HomePage();
          }
        },
      ),
    );
  }
}

