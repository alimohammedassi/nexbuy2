import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'widgets/app_logo.dart';
import 'services/gemini_service.dart';
import 'localization/app_localizations.dart';
import 'providers/language_provider.dart';
import 'providers/category_provider.dart';
import 'utils/theme_utils.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Initialize Gemini service
  GeminiService.initialize();

  // Initialize categories from Supabase (non-blocking)
  // This loads in the background while the app starts
  CategoryProvider.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global navigator key to preserve navigation stack when language changes
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LanguageProvider();
        // Load saved language
        provider.loadSavedLanguage();
        return provider;
      },
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey, // Use navigatorKey instead of key
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            theme: ThemeUtils.buildThemeForLocale(
              languageProvider.currentLocale,
            ),
            // Global background image wrapper with RTL support
            builder: (context, child) {
              final isArabic =
                  Localizations.localeOf(context).languageCode == 'ar';
              return Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Container(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: isArabic
                          ? GoogleFonts.readexProTextTheme(
                              Theme.of(context).textTheme,
                            )
                          : GoogleFonts.bricolageGrotesqueTextTheme(
                              Theme.of(context).textTheme,
                            ),

                      // Make pages show the global background by default
                      scaffoldBackgroundColor: Colors.transparent,
                      canvasColor: Colors.transparent,
                    ),
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              );
            },
            home: const AppSplashScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LiquidGlassLoginPage(),
              '/splash': (context) => const AppSplashScreen(),
              '/admin': (context) => const AdminDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const AppLogoSmall(useAnimatedLogo: true),
            const SizedBox(width: 12),
            Text(widget.title),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
