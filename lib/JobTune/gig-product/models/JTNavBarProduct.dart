import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTChatMessageModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTChatModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAddressScreen.dart';
// import 'package:prokit_flutter/defaultTheme/screen/DTCartScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTChatScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTContactUsScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTErrorScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTFAQScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTFilterScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTForgotPwdScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTMaintenanceScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTNoDataScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTNoResultScreen.dart';
// import 'package:prokit_flutter/defaultTheme/screen/DTOrderSummaryScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTProductDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTProfileScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTReviewScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSignInScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSignUpScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTWalkThoughScreen.dart';
import 'package:prokit_flutter/main/model/ListModels.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'dart:core';

import 'package:prokit_flutter/dashboard/model/db1/Db1Model.dart';
import 'package:prokit_flutter/dashboard/model/db2/Db2Model.dart';
import 'package:prokit_flutter/dashboard/model/db3/Db3Model.dart';
import 'package:prokit_flutter/dashboard/model/db4/Db4Model.dart';
import 'package:prokit_flutter/dashboard/model/db5/Db5Model.dart';
import 'package:prokit_flutter/dashboard/model/db6/Db6Model.dart';
import 'package:prokit_flutter/dashboard/model/db7/Db7Model.dart';
import 'package:prokit_flutter/dashboard/model/db8/Db8Model.dart';
import 'package:prokit_flutter/dashboard/utils/DbImages.dart';

import 'package:prokit_flutter/JobTune/gig-provider/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/my_order/JTOrderScreen.dart';

//import 'JTNewVacanciesUser.dart';

const sender_id = 1;
const receiver_id = 2;

List<ListModel> getDrawerItemsProduct() {
  List<ListModel> drawerItems = [];

  drawerItems.add(ListModel(name: 'My Order', widget: DTCartScreen()));
  drawerItems.add(ListModel(name: 'Order History', widget: DTSignUpScreen()));
  drawerItems
      .add(ListModel(name: 'Provider Account', widget: JTAccountScreenUsers()));

  // drawerItems.add(ListModel(name: '...', widget: DTSignUpScreen()));

  // drawerItems
  //     .add(ListModel(name: 'Change Password', widget: DTForgotPwdScreen()));
  // drawerItems
  //     .add(ListModel(name: 'Cancellation & Refund', widget: DTAboutScreen()));
  // drawerItems
  //     .add(ListModel(name: 'Terms & Condition', widget: DTAboutScreen()));
  // drawerItems.add(ListModel(name: 'Privacy Policy', widget: DTAboutScreen()));
  // drawerItems.add(ListModel(name: 'About', widget: DTAboutScreen()));
  // drawerItems.add(ListModel(name: 'FAQ', widget: DTFAQScreen()));
  // if (isMobile)
  //   drawerItems.add(ListModel(name: 'Contact Us', widget: DTContactUsScreen()));

  return drawerItems;
}
