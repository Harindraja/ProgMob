import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'member.dart';

class AddMemberPage extends StatefulWidget {
  final List<Member> members;

  AddMemberPage(this.members);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController nomorIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  final FocusNode nomorIndukFocusNode = FocusNode();
  final FocusNode namaFocusNode = FocusNode();
  final FocusNode alamatFocusNode = FocusNode();
  final FocusNode tglLahirFocusNode = FocusNode();
  final FocusNode teleponFocusNode = FocusNode();

  final Dio dio = Dio(); // Inisialisasi Dio
  final GetStorage storage = GetStorage(); // Inisialisasi GetStorage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Member',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nomorIndukController,
                focusNode: nomorIndukFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nomor Induk',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: namaController,
                focusNode: namaFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: alamatController,
                focusNode: alamatFocusNode,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: tglLahirController,
                focusNode: tglLahirFocusNode,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tglLahirController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: teleponController,
                focusNode: teleponFocusNode,
                decoration: InputDecoration(
                  labelText: 'Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final newMember = Member(
                    nomor_induk: nomorIndukController.text,
                    nama: namaController.text,
                    alamat: alamatController.text,
                    tgl_lahir: tglLahirController.text,
                    telepon: teleponController.text,
                  );

                  String? token = storage.read('token'); // Dapatkan token dari penyimpanan lokal

                  try {
                    print('Sending data: ${newMember.toJson()}'); // Log data yang dikirim
                    final response = await dio.post(
                      'https://mobileapis.manpits.xyz/api/anggota',
                      data: newMember.toJson(),
                      options: Options(
                        headers: {'Authorization': 'Bearer $token'}, // Gunakan token untuk otentikasi
                      ),
                    );

                    print('Response status: ${response.statusCode}');
                    print('Response data: ${response.data}');

                    if (response.statusCode == 200) {
                      Navigator.pop(context, newMember);
                    } else {
                      _showErrorDialog(context, 'Failed to add member. Status code: ${response.statusCode}, Response: ${response.data}');
                    }
                  } on DioException catch (e) {
                    print('DioException: ${e.response?.statusCode} - ${e.response?.data}');
                    _showErrorDialog(context, 'Error: ${e.response?.statusCode} - ${e.response?.data}');
                  } catch (e) {
                    print('Unexpected error: $e');
                    _showErrorDialog(context, 'Unexpected error: $e');
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
