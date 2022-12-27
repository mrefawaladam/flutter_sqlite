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
  List<Kontak> listKontak = [];
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
          itemCount: listKontak.length,
          itemBuilder: (context, index) {
            Kontak kontak = listKontak[index];
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  size: 50,
                ),
                trailing: GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: ()async{
                    DbHelper().deleteKontak(int.parse(kontak.id.toString()));
                  },
                ),
                title: Text(
                    '${kontak.nama}'
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("NIM: ${kontak.nim}"),
                    )
                  ],
                ),
                onTap: () {
                  _openFormEdit(kontak);
                },

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
      listKontak.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((kontak) {

        //masukan data ke listKontak
        listKontak.add(Kontak.fromMap(kontak));
      });
    });
  }

  //menghapus data Kontak
  Future<void> _deleteKontak(Kontak kontak, int position) async {
    await db.deleteKontak(kontak.id!);
    setState(() {
      listKontak.removeAt(position);
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
  Future<void> _openFormEdit(Kontak kontak) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(nim: int.parse(kontak.nim.toString()), nama: kontak.nama.toString(), alamat: kontak.alamat.toString(), jeniskelamin: kontak.jk.toString(),)));
    if (result == 'update') {
      await _getAllKontak();
    }
  }
}