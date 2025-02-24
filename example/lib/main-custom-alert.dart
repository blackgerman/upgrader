// Copyright (c) 2023 Larry Aasen. All rights reserved.

import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final upgrader = MyUpgrader(debugLogging: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upgrader Example',
      home: MyUpgradeAlert(
          upgrader: upgrader,
          child: Scaffold(
            appBar: AppBar(title: Text('Upgrader Custom Alert Example')),
            body: Center(child: Text('Checking...')),
          )),
    );
  }
}

class MyUpgrader extends Upgrader {
  MyUpgrader({super.debugLogging});

  @override
  bool isTooSoon() {
    return super.isTooSoon();
  }

  @override
  bool isUpdateAvailable() {
    final appStoreVersion = currentAppStoreVersion;
    final installedVersion = currentInstalledVersion;
    print('appStoreVersion=$appStoreVersion');
    print('installedVersion=$installedVersion');
    return super.isUpdateAvailable();
  }
}

class MyUpgradeAlert extends UpgradeAlert {
  MyUpgradeAlert({super.upgrader, super.child});

  /// Override the [createState] method to provide a custom class
  /// with overridden methods.
  @override
  UpgradeAlertState createState() => MyUpgradeAlertState();
}

class MyUpgradeAlertState extends UpgradeAlertState {
  @override
  void showTheDialog({
    Key? key,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool canDismissDialog,
    required UpgraderMessages messages,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: key,
            title: const Text('Update?'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Would you like to update?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  onUserIgnored(context, true);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  onUserUpdated(context, !widget.upgrader.blocked());
                },
              ),
            ],
          );
        });
  }
}
