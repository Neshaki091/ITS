import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plate_model.dart';
import '../services/firebase_service.dart';
import '../view_models/plate_view_model.dart';
import 'plate_detail_page.dart';

class PlatesListPage extends StatefulWidget {
  @override
  _PlatesListPageState createState() => _PlatesListPageState();
}

class _PlatesListPageState extends State<PlatesListPage> {
  final searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlateViewModel>(context);

    final filteredPlates =
        viewModel.plates.where((plate) {
          final query = searchController.text.toLowerCase();
          return plate.plate.toLowerCase().contains(query) ||
              plate.name.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tra cứu biển số')),
        actions: [
          IconButton(
            onPressed: () => FirebaseService().signOut(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      // Bỏ floatingActionButton upload ảnh đi
      // Nếu muốn thêm nút tạo mới biển số (không ảnh), có thể thêm dưới đây:
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAddNewPlateDialog(context, viewModel),
      //   child: Icon(Icons.add),
      // ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: 'Tìm kiếm biển số'),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child:
                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredPlates.isEmpty
                    ? Center(child: Text('Không có dữ liệu'))
                    : ListView.builder(
                      itemCount: filteredPlates.length,
                      itemBuilder: (context, index) {
                        final plate = filteredPlates[index];
                        final isMine = _isMyPlate(plate);
                        return Container(
                          color: isMine ? Colors.blue[50] : Colors.white,
                          child: ListTile(
                            title: Text(plate.plate),
                            subtitle: Text(plate.name),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlateDetailPage(plate: plate),
                                  settings: RouteSettings(arguments: isMine),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  bool _isMyPlate(Plate plate) {
    return getUserEmail() == plate.email;
  }
}
