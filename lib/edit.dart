
import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/kontak.dart';
import 'package:fluttertoast/fluttertoast.dart';


class EditKontak extends StatefulWidget {
  late final Biodata? biodata;

  EditKontak({this.biodata});

  @override
  _EditKontakState createState() => _EditKontakState();
}

class _EditKontakState extends State<EditKontak> {
  DbHelper db = DbHelper();

  TextEditingController nama = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController jk = TextEditingController();
  TextEditingController nim = TextEditingController();

  @override
  void initState() {
    // nama = TextEditingController(
    //     text: widget.kontak == null ? '' : widget.kontak!.nama);
    //
    // nim = TextEditingController(
    //     text: widget.kontak == null ? '' : widget.kontak!.nim);
    //
    // alamat = TextEditingController(
    //     text: widget.kontak == null ? '' : widget.kontak!.alamat);
    //
    // jk = TextEditingController(
    //     text: widget.kontak == null ? '' : widget.kontak!.jk);

    super.initState();
  }

  void submit(BuildContext context, String nama, String nim, String alamat) {
    if (nama.isEmpty || nim.isEmpty || alamat.isEmpty) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Nama, NIM dan Alamat tidak boleh kosong"),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  int _value = 1;//tambahin pemilihan if else
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
              child: (widget.biodata == null)
                  ? const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                submit(context, nama.text, nim.text, alamat.text);
                upsertKontak();
                showToastMessage("Data berhasil ditambahkan");
              },
            ),
          ),

        ],
      ),
    );
  }

  Future<void> upsertKontak() async {
    if (widget.biodata != null) {
      //update
      await db.updateKontak(Biodata(
          id: widget.biodata!.id,
          nama: nama!.text,
          nim: nim!.text,
          alamat: alamat!.text,
          jk: _value == 1 ? 'male' : 'female'
      ));

      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.saveKontak(Biodata(
          nama: nama!.text,
          nim: nim!.text,
          alamat: alamat!.text,
          jk: _value == 1 ? 'male' : 'female'
      ));
      // Navigator.pop(context, 'save');
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