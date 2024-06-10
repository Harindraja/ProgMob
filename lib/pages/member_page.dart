import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'login_page.dart';
import 'add_member.dart'; 
import 'member.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final Dio dio = Dio(); // Inisialisasi Dio
  final GetStorage storage = GetStorage(); // Inisialisasi GetStorage
  List<Member> members = []; // List to store members

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    String? token = storage.read('token');
    try {
      final response = await dio.get(
        'https://mobileapis.manpits.xyz/api/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List<dynamic> data = response.data['data']; // Ambil data anggota dari respons
      List<Member> loadedMembers = data.map((memberData) => Member.fromJson(memberData)).toList(); // Map data anggota ke objek Member
      setState(() {
        members = loadedMembers; // Perbarui daftar anggota dengan data yang dimuat
      });
    } on DioError catch (e) {
      print('Failed to load members: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load members')),
      );
    }
  }

  Future<void> _saveMembers() async {
    List<String> memberStrings = members.map((member) => member.toString()).toList();
    storage.write('members', memberStrings);
  }

  Future<void> _logout(BuildContext context) async {
    String? token = storage.read('token');
    try {
      final response = await dio.get(
        'https://mobileapis.manpits.xyz/api/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('Logout Success: ${response.data}');

      storage.erase(); // Hapus semua data yang disimpan
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(dio: dio, storage: storage, apiUrl: 'https://mobileapis.manpits.xyz/api')),
        (Route<dynamic> route) => false,
      );
    } on DioException catch (e) {
      print('Logout Error: ${e.response?.statusCode} - ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.response?.statusCode}')),
      );
    }
  }

  Future<void> _getUserDetails() async {
    String? token = storage.read('token');
    try {
      final response = await dio.get(
        'https://mobileapis.manpits.xyz/api/user',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('User Details: ${response.data}');
      // TODO: Handle user details response
    } on DioException catch (e) {
      print('Get User Details Error: ${e.response?.statusCode} - ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Get User Details failed: ${e.response?.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hindari menampilkan tombol kembali
        title: Text('Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _getUserDetails,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image(
                    image: AssetImage('lib/images/atas.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final newMember = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMemberPage(members)),
                        );
                        if (newMember != null) {
                          setState(() {
                            members.add(newMember);
                          });
                          _saveMembers();
                        }
                      },
                      child: Text('Add Member'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  child: ListTile(
                    title: Text('Nama: ${member.nama}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nomor Induk: ${member.nomor_induk}'),
                        Text('Alamat: ${member.alamat}'),
                        Text('Tanggal Lahir: ${member.tgl_lahir}'),
                        Text('Telepon: ${member.telepon}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              members.removeAt(index);
                            });
                            _saveMembers();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
