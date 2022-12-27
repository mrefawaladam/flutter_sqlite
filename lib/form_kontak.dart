
import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/kontak.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FormKontak extends StatefulWidget {
  final Kontak? kontak;

  FormKontak({this.kontak});

  @override
  _FormKontakState createState() => _FormKontakState();
}

class _FormKontakState extends State<FormKontak> {
  DbHelper db = DbHelper();

  TextEditingController? nama;
  TextEditingController? lastName;
  TextEditingController? alamat;
  TextEditingController? jk;
  TextEditingController? nim;

  @override
  void initState() {
    nama = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.nama);

    nim = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.nim);

    alamat = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.alamat);

    jk = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.jk);

    super.initState();
  }
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: nama,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: nim,
              decoration: InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: alamat,
              decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Radio(
                  value: 1,
                  groupValue: _value,
                  onChanged: (value){
                    setState(() {
                      _value = value!;
                    });
                  },
                ),
                const SizedBox(width: 10.0,),
                const Text("Male"),
              ],),
              Row(children: [
                Radio(
                  value: 2,
                  groupValue: _value,
                  onChanged: (value1){
                    setState(() {
                      _value = value1!;
                    });
                  },
                ),
                const SizedBox(width: 10.0,),
                const Text("Famale"),
              ],),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 20,
          //   ),
          //   child: TextField(
          //     controller: jk,
          //     decoration: InputDecoration(
          //         labelText: 'Jenis Klamin',
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(8),
          //         )),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20
            ),
            child: ElevatedButton(
              child: (widget.kontak == null)
                  ? Text(
                'Add',
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                upsertKontak();
                showToastMessage("Show Toast Message on Flutter");
              },
            ),
          ),

        ],
      ),
    );
  }

  Future<void> upsertKontak() async {
    if (widget.kontak != null) {
      //update
      await db.updateKontak(Kontak(
          id: widget.kontak!.id,
          nama: nama!.text,
          nim: nim!.text,
          alamat: alamat!.text,
          jk: jk!.text
      ));

      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.saveKontak(Kontak(
        nama: nama!.text,
        nim: nim!.text,
        alamat: alamat!.text,
        jk: jk!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }

  //create this function, so that, you needn't to configure toast every time
  void showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
    );
  }


}