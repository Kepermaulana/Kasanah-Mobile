import 'package:flutter/cupertino.dart';

class StockFormater {
  String formatToBlur(int n) {
    if (n < 5) return "<5";
    if (n < 10) return "<10";
    if (n < 25) return "<25";
    if (n < 50) return "<50";
    if (n < 100) return "<100";
    if (n < 150) return "<150";
    if (n < 200) return "<200";
    if (n < 250) return "<250";
    if (n < 300) return "<300";
    if (n < 450) return "<450";
    if (n < 500) return "<500";
    if (n < 550) return "<550";
    if (n < 600) return "<600";
    if (n < 650) return "<650";
    if (n < 700) return "<700";
    if (n < 750) return "<750";
    if (n < 800) return "<800";
    if (n < 850) return "<850";
    if (n < 900) return "<900";
    if (n < 950) return "<950";
    if (n < 1000) return "<1000";
    return n.toString();
  }

  void checkCounter(int currentStock, int counter, {int zeroing = 0}) {}
}
