import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/themes/app_themes.dart';
import 'app/routes/app_pages.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
    );
  }
}
