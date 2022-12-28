
import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/kontak.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FormKontak extends StatefulWidget {
  final Biodata? biodata;

  FormKontak({this.biodata});

  @override
  _FormKontakState createState() => _FormKontakState();
}

class _FormKontakState extends State<FormKontak> {
  DbHelper db = DbHelper();

  TextEditingController nama = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController jk = TextEditingController();
  TextEditingController nim = TextEditingController();

  @override
  void initState() {
    nama = TextEditingController(
        text: widget.biodata == null ? '' : widget.biodata!.nama);

    nim = TextEditingController(
        text: widget.biodata == null ? '' : widget.biodata!.nim);

    alamat = TextEditingController(
        text: widget.biodata == null ? '' : widget.biodata!.alamat);

    jk = TextEditingController(
        text: widget.biodata == null ? '' : widget.biodata!.jk);

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
    }else{
      upsertKontak();
      showToastMessage("Data berhasil ditambahkan");
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
              top: 50,
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

          Padding(
            padding: const EdgeInsets.only(
                top: 20
            ),

            child: ElevatedButton(
              child: (widget.biodata == null)
                  ? const Text(
                'Tambah Biodata',
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                'Update Biodata',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                submit(context, nama.text, nim.text, alamat.text);

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