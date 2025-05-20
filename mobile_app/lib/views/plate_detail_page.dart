import 'package:flutter/material.dart';
import '../models/plate_model.dart';

class PlateDetailPage extends StatelessWidget {
  final Plate plate;

  const PlateDetailPage({Key? key, required this.plate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMyPlate =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết biển số')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (plate.imageUrl.isNotEmpty)
              Image.network(plate.imageUrl, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text('Biển số: ${plate.plate}', style: TextStyle(fontSize: 18)),
            Text('Chủ xe: ${plate.name}', style: TextStyle(fontSize: 18)),
            Text('Email: ${plate.email}', style: TextStyle(fontSize: 18)),
            if (isMyPlate) ...[
              SizedBox(height: 16),
              Text(
                'Số điện thoại: ${plate.phone}',
                style: TextStyle(fontSize: 16),
              ),
              Text('Tuổi: ${plate.age}', style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
