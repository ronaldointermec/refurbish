import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/Reason.dart';
import 'package:refurbish_web/service/ReasonService.dart';

class ReasonManager extends Manager {
  Stream<List<Reason>> get browse$ =>
      Stream.fromFuture(ReasonService.browse());

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
