import 'dart:async';
import 'package:desktop_app/utils/api/consumer.dart';
import 'package:dio/dio.dart';

import '../model/model_api.dart';

class PresensiRepository {
  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();

  // Ambil list / riwayat presensi
  Future<ApiModel> getPresensi() async {
    return await Consumer()
        .orderBy({'absenTanggal': 'DESC'})
        .limit(10)
        .execute(url: '/presensi/absen');
  }

  Future<ApiModel> getEvent() async {
    return await Consumer()
        .limit(20)
        .orderBy({'tanggal': 'DESC'}).execute(url: '/presensi/event');
  }

  Future<ApiModel> getLokasiPresensi() async {
    return await Consumer().limit(-1).execute(url: '/presensi/lokasiPresensi');
  }

  Future<ApiModel> getPengaturanPresensi() async {
    return await Consumer().limit(-1).execute(url: '/presensi/pengaturan');
  }

  Future<ApiModel> getKecamatan() async {
    return await Consumer()
        .limit(-1)
        .execute(url: '/presensi/kecamatan?isValid[eq]=1');
  }
}
