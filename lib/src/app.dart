import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../helpers/utils.dart';
import '../providers/data_provider.dart';
import 'views/home_view.dart';
import 'views/settings_view.dart';
import 'views/subject_editor.dart';
import 'views/subjects_view.dart';
import 'views/task_editor.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DataProvider()),
      ],
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          title: "My Week Schedule",

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English, no country code
            // Locale('fr', 'FR'), // French,
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          // onGenerateTitle: (BuildContext context) =>
          //     AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF42244A),
              primaryVariant: const Color(0xFF8F659A),
              secondary: const Color(0xFFEF8767),
              secondaryVariant: const Color(0xFFEF8767).withOpacity(0.5),
            ),
            fontFamily: "Poppins",
            primarySwatch: createMaterialColor(const Color(0xFF42244A)),
          ),
          darkTheme: ThemeData.dark(),
          home: const HomeView(),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case TaskEditor.routeName:
                    return const TaskEditor();
                  case SubjectsView.routeName:
                    return const SubjectsView();
                  case SubjectEditor.routeName:
                    return const SubjectEditor();
                  case SettingsView.routeName:
                    return const SettingsView();

                  case HomeView.routeName:
                  default:
                    return const HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
