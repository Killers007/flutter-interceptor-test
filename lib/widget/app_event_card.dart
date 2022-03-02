// ignore_for_file: avoid_unnecessary_containers

import 'package:desktop_app/model/model_event.dart';
import 'package:flutter/material.dart';

class AppEvent extends StatelessWidget {
  final EventModel event;
  const AppEvent(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.nama.toString()),
          Text(
            event.keterangan.toString(),
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
