import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/themes/app_themes.dart';
import 'package:pawnco/app/presentation/web/home/bindings/home_binding.dart';

import 'app/routes/app_pages.dart';

class MainWeb extends StatelessWidget {
  const MainWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
    );
  }
}
