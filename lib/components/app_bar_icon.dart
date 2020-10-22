
import 'package:flutter/material.dart';

IconButton appBarIcon(IconData icon, Function onPressed) => IconButton(
  icon: Icon(icon),
  iconSize: 26,
  splashRadius: 22,
  onPressed: onPressed,
);