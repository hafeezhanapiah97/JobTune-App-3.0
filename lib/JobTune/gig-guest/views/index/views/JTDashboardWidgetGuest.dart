import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTNewVacancies.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardProductWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTDashboardScreenGuest.dart';
import 'JTProductDetailScreenGuest.dart';
import 'JTServiceListCategory.dart';

class JTDashboardWidgetGuest extends StatefulWidget {
  static String tag = '/JTDashboardWidgetGuest';

  @override
  _JTDashboardWidgetGuestState createState() => _JTDashboardWidgetGuestState();
}

class _JTDashboardWidgetGuestState extends State<JTDashboardWidgetGuest> {
//  PageController pageController = PageController();

  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;

  late List<NewVacancies> mListings3;

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkCategory(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      readCategory();
    }
  }

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  Future<void> checkCategory(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory&city="+city
              +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  // functions ends //

  @override
  void initState() {
    super.initState();
    mListings3 = getJobList();
    this.checkProfile();
    init();
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  init() async {
    pages = [
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Home.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Home Tuition/ Tutor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Religious.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Religious",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Baby Sitting.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Baby Sitting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Photographer.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Photography",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Mobile Salon.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Mobile Salon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Kitchen Assistant.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Kitchen Assistant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Lawn Mowing.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Lawn Mowing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Data Entry.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Data Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
    ];

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 375.0,
              floating: true,
              pinned: true,
              snap: false,
              automaticallyImplyLeading : false,
              backgroundColor: appStore.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: appColorPrimary,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      ).visible(false),
                      Column(
                        children: [
                          15.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                                  Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                    appStore.setDrawerItemIndex(-1);

                                    if (isMobile) {
                                      JTDashboardSreenUser().launch(context, isNewTask: true);
                                    } else {
                                      //                                  DTDashboardScreen().launch(context, isNewTask: true);
                                    }
                                  }),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(right: 8, top: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: categories.map((e) {
                                    return Container(
                                      width: isMobile ? 100 : 120,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                                            child: Image.asset(e.icon!, height: 30, width: 30, color: white),
                                          ),
                                          4.height,
                                          Text(
                                              e.name!,
                                              style: primaryTextStyle(size: 12),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ],
                                      ),
                                    ).onTap(() {
                                      // JTServiceListCategory().launch(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => JTServiceListCategory(
                                          searchkey: e.name!,
                                        )),
                                      );
                                    });
                                  }).toList(),
                                ),
                              ),
                              20.height,
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 170,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView(
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  children: pages,
                                  onPageChanged: (index) {
                                    selectedIndex = index;
                                    setState(() {});
                                  },
                                ).cornerRadiusWithClipRRect(8),
                                DotIndicator(
                                  pages: pages,
                                  indicatorColor: appColorPrimary,
                                  pageController: pageController,
                                ),
                              ],
                            ),
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' Product Listing', style: boldTextStyle()).paddingAll(8),
                              Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          ];
        },
        body: Container(height: 390, child: JTProductList()),
      )
    );
  }
}
