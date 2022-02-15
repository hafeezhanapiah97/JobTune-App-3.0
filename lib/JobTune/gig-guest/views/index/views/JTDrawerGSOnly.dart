import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/forgot-password/JTForgotPasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/maintenance/JTMaintenanceScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/signup-login/JTSignInEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTNavbarUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTOnboardingScreenProvider.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main/model/ListModels.dart';
import 'package:prokit_flutter/main/screens/ProKitLauncher.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';

import '../../../../../main.dart';



bool seen = false;

class JTDrawerGSOnlyWidgetUser extends StatefulWidget {
  static String tag = '/JTDrawerGSOnlyWidgetUser';

  @override
  _JTDrawerGSOnlyWidgetUserState createState() => _JTDrawerGSOnlyWidgetUserState();
}

class _JTDrawerGSOnlyWidgetUserState extends State<JTDrawerGSOnlyWidgetUser> {
  List<NavbarUserList> drawerItems = getDrawerItemsService();
  var scrollController = ScrollController();

  // functions starts//

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    // await prefs.clear();

    JTDashboardScreenGuest().launch(context, isNewTask: true);
  }

  int loginstat = 0;
  Future<void> readUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    setState(() {
      if(lgid == "null") {
        loginstat = 0;
      }
      else{
        loginstat = 1;
      }
    });
  }

  Future<void> gotoEmployer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgemployer = prefs.getString('employerID').toString();
    if (lgemployer == "null") {
      JTSignInScreenEmployer().launch(context, isNewTask: true);
    } else {
      JTDashboardScreenNomad(id: "Employer").launch(context, isNewTask: true);
    }
  }

  @override
  void initState() {
    super.initState();
    this.readUser();
    init();
  }

  // functions ends//



  init() async {
    if (appStore.selectedDrawerItem > 7) {
      await Future.delayed(Duration(milliseconds: 300));
      scrollController.jumpTo(appStore.selectedDrawerItem * 27.0);

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print(loginstat);
    return SafeArea(
      child: ClipPath(
        clipper: OvalRightBorderClipper(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            color: appStore.scaffoldBackground,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  16.height,
                  Text('Home', style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                  4.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Home', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
                      // ProKitLauncher().launch(context, isNewTask: true);
                      JTDashboardScreenGuest().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Service',
                        style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    JTDashboardSreenUser().launch(context, isNewTask: true);
                  }),
                  Divider(height: 16, color: Colors.blueGrey),
                  (loginstat == 0)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Log In/ Create account', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        JTSignInScreen().launch(context, isNewTask: true);
                      }),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Forgot Password', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        JTForgotPasswordScreen().launch(context, isNewTask: true);
                      }),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Change Password',
                            style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        JTChangePasswordScreen().launch(context, isNewTask: true);
                      }),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Logout',
                            style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        logout();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


