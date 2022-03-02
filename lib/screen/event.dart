import 'dart:ui';

import 'package:desktop_app/states/state.dart';
import 'package:desktop_app/widget/app_event_card.dart';
import 'package:desktop_app/widget/app_skeleton.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  // // Authentikasi
  // void auth() async {
  //   final auth =
  //       await Consumer().auth(username: '130239244', password: '1q2w3e4r');

  //   if (auth.code == CODE.SUCCESS) {
  //     UtilPreferences.setToken(
  //         accessToken: auth.data['accessToken'],
  //         refreshToken: auth.data['refreshToken']);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // showDebugBtn(context, btnColor: Colors.blue);
    EventState eventState = Provider.of<EventState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      body: RefreshIndicator(
          child: wContent(context, eventState),
          onRefresh: eventState.refreshData),
    );
  }

  // Content Render Widget
  Widget wContent(BuildContext context, EventState eventState) {
    if (eventState.error != null) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView(
          children: [Text(eventState.error?['title'])],
        ),
      );
    } else if (eventState.data == null) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView(
          children: List.generate(10, (index) => wLoading(context)).toList(),
        ),
      );
    } else {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: eventState.data!.rows!.map((e) => AppEvent(e)).toList(),
        ),
      );
    }
  }

  // Loading Widget
  Widget wLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppSkeleton(
            height: 20,
            width: 100,
          ),
          SizedBox(height: 5),
          AppSkeleton(
            height: 20,
          ),
        ],
      ),
    );
  }
}
