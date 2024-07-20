import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_app/src/app/app_view.dart';
import 'package:starter_app/src/configs/app_setup.locator.dart';
import 'package:starter_app/src/configs/setup_bottom_sheet.dart';
import 'package:starter_app/src/configs/supabase_setup.dart';
import 'package:starter_app/src/services/local/auth_service.dart';
import 'package:starter_app/src/services/local/flavor_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:starter_app/src/services/remote/supabase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize supabase
  await SupabaseSetup.init();
  AuthService.prefs = await SharedPreferences.getInstance();
  SupabaseAuthService.prefs = await SharedPreferences.getInstance();

  // getting package
  final package = await PackageInfo.fromPlatform();

  setupLocator();
  setupBottomSheet();

  // app flavor init
  FlavorService.init(package);

  runApp(AppView());
}


//TODO: 
// 1. add the events list inside the data viewmodel so that we can show the events without reentering the credentials.
// 2. fix some ui issues
// 3. calculate the total working hours now and send it to tanzeel.