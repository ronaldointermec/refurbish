import 'package:flutter/material.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:rxdart/rxdart.dart';

class ScannerManager with WidgetsBindingObserver implements ScannerCallBack {
  HoneywellScanner honeywellScanner = HoneywellScanner();
  bool scannerEnabled = true;
  bool scan1DFormats = true;
  bool scan2DFormats = true;

  updateScanProperties() {
    List<CodeFormat> codeFormats = [];
    if (scan1DFormats ?? false)
      codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    if (scan2DFormats ?? false)
      codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
    honeywellScanner
        .setProperties(CodeFormatUtils.getAsPropertiesComplement(codeFormats));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (honeywellScanner != null) honeywellScanner.resumeScanner();
        break;
      case AppLifecycleState.inactive:
        if (honeywellScanner != null) honeywellScanner.pauseScanner();
        break;
      case AppLifecycleState
          .paused: //AppLifecycleState.paused is used as stopped state because deactivate() works more as a pause for lifecycle
        if (honeywellScanner != null) honeywellScanner.pauseScanner();
        break;
      case AppLifecycleState.detached:
        if (honeywellScanner != null) honeywellScanner.pauseScanner();
        break;
      default:
        break;
    }
  }

  dispose() {
    if (honeywellScanner != null) honeywellScanner.stopScanner();
    if (_controller != null) _controller.close();
  }

  ScannerManager() {
    WidgetsBinding.instance.addObserver(this);
    honeywellScanner.setScannerCallBack(this);
    updateScanProperties();
    honeywellScanner.startScanner();
  }

  BehaviorSubject<String> _controller = BehaviorSubject<String>();

  Stream<String> get getCode => _controller.stream;

  @override
  void onDecoded(String result) {
    _controller.add(result);
  }

  @override
  void onError(Exception error) {
    _controller.add(error.toString());
  }
}
