import 'package:flutter/foundation.dart' show kIsWeb;

String AssetPath(str) => (!kIsWeb) ? 'assets/$str' : str;
