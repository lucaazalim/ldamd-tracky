import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/services/orders_service.dart';
import 'package:mobile/modules/common/components/theme_provider.dart';
import 'package:provider/provider.dart';

/// A page that allows drivers to update the status of an order.
///
/// This page includes a camera interface for capturing images and a dropdown to select the new status.
class UpdateOrderStatusPage extends StatefulWidget {
  const UpdateOrderStatusPage({super.key});

  @override
  State<UpdateOrderStatusPage> createState() => _UpdateOrderStatusPageState();
}

class _UpdateOrderStatusPageState extends State<UpdateOrderStatusPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  OrderStatus? _selectedStatus;

  final List<OrderStatus> _statuses = OrderStatus.values;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    return _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //validating data passed on args;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Order) {
      return const Scaffold(
        body: Center(child: Text('Delivery data not provided.')),
      );
    }

    final order = args;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Change Order Status'),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 5, 242, 112),
          fontSize: 24.0,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Capture Delivery Evidence',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 300,
                    child: CameraPreview(_cameraController),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error initializing camera: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Select New Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<OrderStatus>(
              value: _selectedStatus,
              hint: const Text('Choose a status'),
              isExpanded: true,
              onChanged: (OrderStatus? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: _statuses.map((OrderStatus status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(status.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {

                if (_selectedStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a status')),
                  );
                  return;
                }

                try {

                  await _initializeControllerFuture;

                  XFile image = await _cameraController.takePicture();
                  print(order.id);
                  print(_selectedStatus!.name.toUpperCase());
                  await OrdersService().updateOrderStatus(order.id, _selectedStatus!.name.toUpperCase());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status changed to: ${_selectedStatus!.name}')),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update status: $e')),
                  );

                }
              },
              child: const Text('Confirm Status Change'),
            ),
          ],
        ),
      ),
    );
  }
}