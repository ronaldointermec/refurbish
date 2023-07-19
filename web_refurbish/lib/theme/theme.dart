import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{

  static Color scaffoldBackgroundColor = Color(0xFF262A41);

  static ThemeData getTheme(BuildContext context){

    return Theme.of(context).copyWith(
       scaffoldBackgroundColor: scaffoldBackgroundColor,
     textTheme: GoogleFonts.sourceSansProTextTheme(),

    );

  }
}