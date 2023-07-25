import 'package:audre/create_profile.dart';
import 'package:audre/home.dart';
import 'package:audre/login_screen.dart';
import 'package:audre/models/user_model.dart';
import 'package:audre/other_user_profile_screen.dart';
import 'package:audre/post_record_screen.dart';
import 'package:audre/post_screen.dart';
import 'package:audre/profile_screen.dart';
import 'package:audre/providers/user_provider.dart';
import 'package:audre/services/graphql_services.dart';
import 'package:audre/services/user_graphql_services.dart';
// import 'package:audre/services/user_graphql_services.dart';
import 'package:audre/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GraphQLProvider(
      client: client,
      child: const TextSelectionTheme(
        data: TextSelectionThemeData(
          cursorColor: Colors.white, // Set the cursor color here
        ),
        child: ProviderScope(child: MyApp()),
      )));
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audre',
      theme: ThemeData(
        primarySwatch: primaryBlack,
        splashColor: primaryBlack.shade900,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const MyHomePage();
            break;
          case '/login':
            builder = (BuildContext context) => const LoginScreen();
            break;
          case '/home':
            builder = (BuildContext context) {
              return const Home();
            };
            break;
          case '/profile':
            builder = (BuildContext context) {
              String args = settings.arguments as String;
              return OtherUserProfileScreen(uid: args);
            };
            break;
          case '/create-profile':
            builder = (BuildContext context) {
              return const CreateProfile();
            };
            break;
          case '/record-post':
            builder = (BuildContext context) {
              return const PostRecordScreen();
            };
            break;
          case '/create-post':
            builder = (BuildContext context) {
              Map<String, String> args =
                  settings.arguments as Map<String, String>;
              return PostScreen(
                audioUrl: args['audioUrl'] ?? '',
                audioPath: args['audioPath'] ?? '',
              );
            };
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return PageTransition<dynamic>(
          child: builder(context),
          type: PageTransitionType
              .rightToLeft, // Choose your desired transition type
          duration: const Duration(
              milliseconds: 500), // Set the duration of the transition
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nextPage = '';

  Future<void> navigateToNextPage() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      print(uid);
      if (uid == '') {
        setState(() {
          nextPage = '/login';
        });
        return;
      }

      UserModal? user = await UserGraphQLService.getUser(uid);

      if (user == null) {
        FirebaseUserProvider.setUser(FirebaseAuth.instance.currentUser!);
        setState(() {
          nextPage = '/create-profile';
        });
      } else {
        UserProvider.setUser(user);
        setState(() {
          nextPage = '/home';
        });
      }
    } catch (e) {
      print(e);
      // Handle the error appropriately, e.g., show an error message
    }
  }

  @override
  void initState() {
    super.initState();
    navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // return const PostScreen(audioPath: '', audioUrl: '');
    switch (nextPage) {
      case '/login':
        return const LoginScreen();
      case '/home':
        return const Home();
      case '/create-profile':
        return const CreateProfile();
      default:
        return Scaffold(
            extendBody: true,
            body: Container(
                color: const Color.fromARGB(0, 17, 16, 16),
                child: const Splash()));
    }
  }
}
