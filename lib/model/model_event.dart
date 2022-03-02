// To parse this JSON data, do
//
//     final eventModel = eventModelFromMap(jsonString);

// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';

class EventListModel {
  EventListModel({
    this.rows,
  });

  final List<EventModel>? rows;

  factory EventListModel.fromJson(String str) =>
      EventListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EventListModel.fromMap(Map<String, dynamic> json) => EventListModel(
        rows: json["rows"] == null
            ? null
            : List<EventModel>.from(
                json["rows"].map((x) => EventModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toMap())),
      };
}

class EventModel {
  EventModel({
    this.id,
    this.nama,
    this.tanggal,
    this.keterangan,
  });

  final String? id;
  final String? nama;
  final String? tanggal;
  final String? keterangan;

  factory EventModel.fromJson(String str) =>
      EventModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EventModel.fromMap(Map<String, dynamic> json) => EventModel(
        id: json["id"] ?? null,
        nama: json["nama"] ?? null,
        tanggal: json["tanggal"] ?? null,
        keterangan: json["keterangan"] ?? null,
      );

  Map<String, dynamic> toMap() => {
        "id": id ?? null,
        "nama": nama ?? null,
        "tanggal": tanggal ?? null,
        "keterangan": keterangan ?? null,
      };
}
