import 'package:flutter/material.dart';
import 'package:learningsqlite/detail.dart';
import 'form_kontak.dart';

import 'database/db_helper.dart';
import 'model/kontak.dart';

class ListKontakPage extends StatefulWidget {
  const ListKontakPage({ Key? key }) : super(key: key);

  @override
  _ListKontakPageState createState() => _ListKontakPageState();
}

class _ListKontakPageState extends State<ListKontakPage> {
  List<Biodata> listBiodata = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    //menjalankan fungsi getallkontak saat pertama kali dimuat
    _getAllKontak();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ListView.builder(
          itemCount: listBiodata.length,
          itemBuilder: (context, index) {
            Biodata biodata = listBiodata[index];
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  size: 50,
                ),

                title: Text(
                    '${biodata.nama}'
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("NIM: ${biodata.nim}"),
                    )
                  ],
                ),
                onTap: () {
                  _openFormDetail(biodata);
                },
                trailing:
                FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
                      // button edit
                      IconButton(
                          onPressed: () {
                            _openFormEdit(biodata);
                          },
                          icon: Icon(Icons.edit)
                      ),
                      // button hapus
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          //membuat dialog konfirmasi hapus
                          AlertDialog hapus = AlertDialog(
                            title: Text("Information"),
                            content: Container(
                              height: 100,
                              child: Column(
                                children: [
                                  Text(
                                      "Yakin ingin Menghapus Data ${biodata.nama}"
                                  )
                                ],
                              ),
                            ),
                            //terdapat 2 button.
                            //jika ya maka jalankan _deleteKontak() dan tutup dialog
                            //jika tidak maka tutup dialog
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    _deleteKontak(biodata, index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ya")
                              ),
                              TextButton(
                                child: Text('Tidak'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                          showDialog(context: context, builder: (context) => hapus);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      //membuat button mengapung di bagian bawah kanan layar


    );
  }

  //mengambil semua data Kontak
  Future<void> _getAllKontak() async {
    //list menampung data dari database
    var list = await db.getAllKontak();

    //ada perubahanan state
    setState(() {
      //hapus data pada listKontak
      listBiodata.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((kontak) {

        //masukan data ke listKontak
        listBiodata.add(Biodata.fromMap(kontak));
      });
    });
  }

  //menghapus data Kontak
  Future<void> _deleteKontak(Biodata kontak, int position) async {
    await db.deleteKontak(kontak.id!);
    setState(() {
      listBiodata.removeAt(position);
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormKontak()));
    if (result == 'save') {
      await _getAllKontak();
    }
  }

  //membuka halaman edit Kontak
  Future<void> _openFormEdit(Biodata kontak) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => FormKontak(biodata: kontak)));
    if (result == 'update') {
      await _getAllKontak();
    }
  }

  Future<void> _openFormDetail(Biodata kontak) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(nim: int.parse(kontak.nim.toString()), nama: kontak.nama.toString(), alamat: kontak.alamat.toString(), jeniskelamin: kontak.jk.toString(),)));

  }
}