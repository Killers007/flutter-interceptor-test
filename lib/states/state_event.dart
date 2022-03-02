import 'package:desktop_app/api/repository.dart';
import 'package:desktop_app/model/model_api.dart';
import 'package:desktop_app/model/model_event.dart';
import 'package:flutter/foundation.dart';

class EventState with ChangeNotifier, DiagnosticableTreeMixin {
  EventListModel? data;
  Map<String, dynamic>? error;

  EventState() {
    initData();
  }

  Future<void> initData() async {
    final res = await PresensiRepository().getEvent();
    if (res.code == CODE.SUCCESS) {
      data = EventListModel.fromMap(res.data);
      notifyListeners();
    } else {
      error = res.message;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    error = null;
    data = null;
    notifyListeners();
    initData();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
