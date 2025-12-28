import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TimeOfDay fromStampToTime(Timestamp timestamp) {
  int milliSeconds = timestamp.millisecondsSinceEpoch;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliSeconds);
  TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
  return timeOfDay;
}
