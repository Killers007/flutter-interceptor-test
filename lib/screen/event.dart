import 'dart:ui';

import 'package:desktop_app/api/repository.dart';
import 'package:desktop_app/config/application.dart';
import 'package:desktop_app/model/model_api.dart';
import 'package:desktop_app/model/model_event.dart';
import 'package:desktop_app/utils/api/consumer.dart';
import 'package:desktop_app/utils/logger.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:desktop_app/widget/app_event_card.dart';
import 'package:desktop_app/widget/app_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Event extends StatelessWidget {
  const Event({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventScreen(title: 'Event'),
    );
  }
}

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventListModel? eventData;

  @override
  void initState() {
    // auth();
    initData();
    super.initState();
  }

  // Authentikasi
  void auth() async {
    final auth =
        await Consumer().auth(username: '130239244', password: '1q2w3e4r');

    if (auth.code == CODE.SUCCESS) {
      UtilPreferences.setToken(
          accessToken: auth.data['accessToken'],
          refreshToken: auth.data['refreshToken']);
    }
  }

  // Get Data Event Form Api
  void initData() async {
    await Future.delayed(const Duration(seconds: 3));

    // Get Event form repository
    final data = await PresensiRepository().getEvent();

    if (data.code == CODE.SUCCESS) {
      setState(() {
        // Parse data to object model
        eventData = EventListModel.fromMap(data.data);
      });
      UtilLogger.log('DATA', data);
    }
  }

  Future<void> refreshData() async {
    setState(() {
      eventData = null;
    });
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(child: wContent(), onRefresh: refreshData),
    );
  }

  final ScrollController _scrollController = ScrollController();
  // Content Render Widget
  Widget wContent() {
    if (eventData == null) {
      return ListView(
        children: [1, 2, 3, 4].map((e) => wLoading()).toList(),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: eventData!.rows!.map((e) => AppEvent(e)).toList(),
      ),
    );
  }

  // Loading Widget
  Widget wLoading() {
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
