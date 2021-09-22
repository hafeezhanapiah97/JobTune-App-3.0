import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/resume/JTResumeScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart';

import '../../../../main.dart';


class JTJobAlertScreen extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  JTJobAlertScreen({this.mIsEditable, this.isOrderSummary});

  @override
  JTJobAlertScreenState createState() => JTJobAlertScreenState();
}

class JTJobAlertScreenState extends State<JTJobAlertScreen> {

  List alertlist = [];
  Future<void> readAlert() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();
    http.Response response = await http.get(
        Uri.parse(server + "jtnew_employer_selectjobalert&id="+lgid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      alertlist = json.decode(response.body);
    });

    for(var m=0; m<alertlist.length; m++){
      readAccept(alertlist[m]["job_id"],alertlist[m]["employee_id"],m);
    }
  }

  List slindex = [];
  List accepted = [];
  Future<void> readAccept(jobid,empid,m) async {
    http.Response response = await http.get(
        Uri.parse(server + "jtnew_employer_checkshortlist&id="+jobid+"&empid="+empid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      accepted = json.decode(response.body);
    });

    if(accepted.length>0){
      slindex.add("shortlisted");
    }
    else{
      slindex.add("no");
    }

    print(slindex);
  }

  @override
  void initState() {
    super.initState();
    this.readAlert();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: alertlist == null ? 0 : alertlist.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: appStore.appBarColor!),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          image + alertlist[index]["profile_pic"]),
                      // radius: 35,
                    )
                    ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(alertlist[index]["job_type"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        Text(
                          alertlist[index]["job_name"],
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: appStore.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Text('Applicant : ' + alertlist[index]["first_name"] + " " + alertlist[index]["last_name"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Text('Specialize : ' + alertlist[index]["category"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Row(
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: appDark_parrot_green,
                          ),
                          padding: EdgeInsets.all(6.5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              6.width,
                              Text('View',
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                            ],
                          ),
                        ).onTap(() async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JTResumeScreen(
                              id: alertlist[index]["employee_id"],
                              job: alertlist[index]["job_id"],
                              empr: alertlist[index]["employer_id"],
                            )),
                          );
                        }),
                        10.width,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: appColorPrimaryDark,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              6.width,
                              Text('Shortlist',
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                              Icon(Icons.check_rounded, color: whiteColor)
                                  .onTap(() {}),
                            ],
                          ),
                        ).onTap(() async {
                          showInDialog(context,
                              child: AcceptRequestDialog(
                                id: alertlist[index]["job_id"],
                                emp: alertlist[index]["employee_id"],
                              ),
                              backgroundColor: Colors.transparent,
                              contentPadding: EdgeInsets.all(0));
                        })
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        });
  }
}

class AcceptRequestDialog extends StatefulWidget {
  var id;
  var emp;

  AcceptRequestDialog({
    this.id,
    this.emp,
  });

  @override
  _AcceptRequestDialogState createState() => _AcceptRequestDialogState();
}

class _AcceptRequestDialogState extends State<AcceptRequestDialog> {
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  Future<void> addShortlist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('employerID');

    http.get(
        Uri.parse(server +
            "jtnew_employer_insertshortlist&jpostid=" + widget.id +
            "&jemployeeid=" + widget.emp +
            "&jemployerid=" + jobtuneUser.toString()
        ),
        headers: {"Accept": "application/json"});

    Navigator.pop(context);
    showInDialog(context,
        child: AlertAdded(),
        backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));

    toast("Request accepted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shortlist Candidate', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                Text('Are you sure you want to add this candidate to your shortlist?'),
                16.height,
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            addShortlist();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Center(
                              child: Text("Yes",
                                  style: boldTextStyle(color: white)),
                            ),
                          ),
                        )),
                    8.width,
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child:
                                Text("Cancel", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlertAdded extends StatefulWidget {
  @override
  _AlertAddedState createState() => _AlertAddedState();
}

class _AlertAddedState extends State<AlertAdded> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/resized/shortlist.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Candidate Shortlisted!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "You can now view the list of candidates you have added to the shortlist and send offers to those who qualify.",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Later", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => JTSignUpScreen()),
                          // );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("View Now", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              7.height,
            ],
          ),
        ),
      ),
    );
  }
}