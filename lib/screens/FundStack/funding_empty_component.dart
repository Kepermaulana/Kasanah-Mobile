import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';

class FundingEmptyComponent extends StatelessWidget {
  const FundingEmptyComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              child: Text(
                'Status Pendanaan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: greenColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Infromasi KUR:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nominal',
                          style: TextStyle(),
                        ),
                        Spacer(),
                        Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tanggal Kontrak',
                          style: TextStyle(),
                        ),
                        Spacer(),
                        Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tenor',
                          style: TextStyle(),
                        ),
                        Spacer(),
                        Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Jatuh Tempo Pembayaran',
                          style: TextStyle(),
                        ),
                        const Spacer(),
                        const Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bunga',
                          style: TextStyle(),
                        ),
                        Spacer(),
                        Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Total Pelunasan',
                          style: TextStyle(),
                        ),
                        const Spacer(),
                        const Text('-')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          tilePadding: const EdgeInsets.all(0),
                          childrenPadding: const EdgeInsets.all(0),
                          textColor: blackColor,
                          iconColor: blackColor,
                          title: const Text('Proses Pengajuan',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          children: const <Widget>[
                            ListTile(title: Text('-')),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          tilePadding: const EdgeInsets.all(0),
                          childrenPadding: const EdgeInsets.all(0),
                          textColor: blackColor,
                          iconColor: blackColor,
                          title: const Text('Riwayat Pengajuan',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          children: const <Widget>[
                            ListTile(title: Text('-')),
                          ],
                        )
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
