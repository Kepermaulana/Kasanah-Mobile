import 'package:flutter/material.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';

void showComingSoonFeatureMsg({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return WDialog_TextAlert(
          context, "Coming Soon!", "maaf, fitur ini akan segara hadir");
    },
  );
}
