import 'package:flutter/material.dart';

// 独立的 ThemeClass
class MyTheme {
  // 定义主题的方法
  static ThemeData lightTheme() {
    return ThemeData(
      // 主要颜色
      primaryColor: Colors.blue,
      // 背景颜色
      scaffoldBackgroundColor: Colors.white,
      // AppBar 样式
      appBarTheme: AppBarTheme(
        color: Colors.blueAccent,
        elevation: 2,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      )
    );
  }

  // 如果你需要深色主题，可以这样添加
  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.grey[900],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      )
    );
  }
}
