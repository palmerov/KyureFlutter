import 'package:flutter/widgets.dart';

class Option{
  Option(this.title, this.icon, this.onTap);
  final String title;
  final Widget icon;
  final Function() onTap;
}