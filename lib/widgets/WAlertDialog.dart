import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';

Dialog WDialong_ConfirmAlert(BuildContext context, String title,
    {description = '',
    confirm = 'Lanjut',
    cancel = 'Batal',
    VoidCallback? onConfirm}) {
  double mediaW = MediaQuery.of(context).size.width;
  return Dialog(
    elevation: 0,
    backgroundColor: c.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(description),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: mediaW,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () async {
                onConfirm!();
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  confirm,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: mediaW,
            height: 50,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  cancel,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Dialog WDialog_TextAlert(
    BuildContext context, String title, String description) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Dialog(
    elevation: 0,
    backgroundColor: c.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      width: mediaW / 1.5,
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(description),
          ),
        ],
      ),
    ),
  );
}

Dialog WDialong_SignOut(BuildContext context, String title,
    {description = '',
    confirm = 'Keluar',
    cancel = 'Batal',
    VoidCallback? onConfirm}) {
  double mediaW = MediaQuery.of(context).size.width;
  return Dialog(
    elevation: 0,
    backgroundColor: c.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(description),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: mediaW,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () async {
                onConfirm!();
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  confirm,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: c.redColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: mediaW,
            height: 50,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  cancel,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}