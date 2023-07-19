import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';
import 'package:refurbish_web/service/report/PosicaoEstoqueService.dart';
import 'package:rxdart/rxdart.dart';

class PosicaoStoqueManager extends Manager {
  PublishSubject<List<PosicaoEstoque>> _collectionPosicaoStoque =
      PublishSubject<List<PosicaoEstoque>>();

  PublishSubject<Map<String, String>> _filterPosicaoStoque = PublishSubject<Map<String, String>>();

  Stream<List<PosicaoEstoque>> get browse$ => _collectionPosicaoStoque.stream;

  Sink<Map<String, String>> get inFilter => _filterPosicaoStoque.sink;

  PosicaoStoqueManager() {
    _filterPosicaoStoque
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((body) async* {
      yield await PosicaoEstoqueService.browse(body);
    }).listen((posicaoEstoque) async {
      _collectionPosicaoStoque.add(posicaoEstoque);
    });


  }

  @override
  void dispose() {
    _collectionPosicaoStoque.close();
  }
}
