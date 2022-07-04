import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../button/button.dart';
import 'error.dart';
import '../text/text_suhu.dart';

class Sucess extends StatelessWidget {
  const Sucess({
    Key? key,
    required this.data,
    required this.starCountRef,
    required this.id,
  }) : super(key: key);

  final Map data;
  final String id;
  final DatabaseReference starCountRef;

  @override
  Widget build(BuildContext context) {
    Future updateData(String key, bool isOn, int value) async {
      await FirebaseDatabase.instance.ref().child(key).update({'isOn': isOn});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Hy User",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: Text(
            "Mac $id",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextSuhu(
              dataSuhu: "${data['Temperatur_fan']['value']} %",
              title: 'Temperatur',
            ),
            TextSuhu(
              dataSuhu: "${data['Humidity_lampu']['value']} °C",
              title: 'Humidity',
            ),
          ],
        ),
        const Divider(thickness: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SwitchCostum(
              value: data['Temperatur_fan']['isOn'],
              onChanged: data['isClick']
                  ? (value) async {
                      await updateData(
                        'Temperatur_fan',
                        value,
                        data['Temperatur_fan']['value'],
                      );
                    }
                  : null,
              title: 'Fan',
            ),
            SwitchCostum(
              value: data['Humidity_lampu']['isOn'],
              onChanged: data['isClick']
                  ? (value) async {
                      await updateData(
                        'Humidity_lampu',
                        value,
                        data['Humidity_lampu']['value'],
                      );
                    }
                  : null,
              title: 'Lampu',
            ),
          ],
        ),
        const Divider(thickness: 2),
        Center(
          child: data['isClick']
              ? ButtonOn(
                  title: 'On',
                  onPressed: () async {
                    starCountRef.update({'isClick': !data['isClick']});
                  },
                )
              : ButtonOff(
                  title: 'Off',
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
