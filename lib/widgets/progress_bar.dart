import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryColor,),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        primaryColor,
      ),
    ),
  );
}