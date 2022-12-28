import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learningsqlite/edit.dart';
import 'package:learningsqlite/main.dart';

class DetailPage extends StatelessWidget {
  final int nim;
  final String nama;
  final String alamat;
  final String jeniskelamin;

  static const appTitle = 'Home';

  const DetailPage(
      {super.key,
        required this.nim,
        required this.nama,
        required this.alamat,
        required this.jeniskelamin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Detail Page"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              // margin: const EdgeInsets.only(left: 135, right: 100, top: 80),
              child: Icon(
                Icons.person,
                size: 150,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  nim.toString(),
                )),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(nama),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(alamat),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              // margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
              child: Text(jeniskelamin.toString()),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                  // validate nim}
                },
                child: const Text('Back'),
              ),

            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditKontak()));
                  // validate nim}
                },
                child: const Text('Edit'),
              ),

            ),

          ],
        ),
      ),
    );

    // TODO: implement build
  }
}