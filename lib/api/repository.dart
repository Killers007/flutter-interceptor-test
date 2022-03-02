import 'dart:async';
import 'package:desktop_app/utils/api/consumer.dart';

import '../model/model_api.dart';

class PresensiRepository {
  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();

  Future<ApiModel> getEvent() async {
    return await Consumer()
        .limit(20)
        .orderBy({'tanggal': 'DESC'}).execute(url: '/presensi/event');
  }
}
