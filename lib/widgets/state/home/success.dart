import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../button/button.dart';
import '../error.dart';
import '../../text/text_suhu.dart';

class HomeSucess extends StatelessWidget {
  const HomeSucess({
    Key? key,
    required this.data,
    required this.starCountRef,
  }) : super(key: key);

  final Map data;
  final DatabaseReference starCountRef;

  @override
  Widget build(BuildContext context) {
    Future updateData(String key, bool isOn) async {
      await FirebaseDatabase.instance.ref().update({key: isOn});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 15,
        // ),
        // tampilan mac user yang terhubung
        
        const SizedBox(
          height: 15,
        ),
        Center(
          child: TextSuhu(
            dataSuhu: "${data['Humidity_lampu']['value']} %",
            title: 'water level',
          ),
        ),
        const Divider(thickness: 2),
        Center(
          child: SwitchCostum(
            value: data['Humidity_lampu_isOn'],
            onChanged: data['isClick']
                ? (value) async {
                    await updateData(
                      'Humidity_lampu_isOn',
                      value,
                    );
                  }
                : null,
            title: data['Humidity_lampu_isOn'] ? 'On' : "Off",
          ),
        ),
        const Divider(thickness: 2),
        Center(
          child: data['isClick']
              ? 
              // tombol manual
              ButtonOn(
                  title: 'Manual',
                  onPressed: () async {
                    starCountRef.update({'isClick': !data['isClick']});
                  },
                )
              : 
              // tombol otomatis
              ButtonOff(
                  title: 'Otomatis',
                  onPressed: () async {
                    starCountRef.update({'isClick': !data['isClick']});
                  },
                ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}
