import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:luggo/services/shared_prefs_service.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  Future<List<Map<String, dynamic>>> _getUserServices(String userId) async {
    List<Map<String, dynamic>> services = [];

    final snapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('userId', isEqualTo: userId)
            .orderBy('creacionTimestamp', descending: true)
            .get();


    for (var entrada in snapshot.docs) {
      services.add(entrada.data());
    }

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      body: FutureBuilder<String?>(
        future: SharedPrefsService().getUserUUID(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          String uid = userSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getUserServices(uid),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (dataSnapshot.hasError) {
                return const Center(child: Text('Error'));
              }

              List<Map<String, dynamic>> services = dataSnapshot.data ?? [];

              if (services.isEmpty) {
                return const Center(child: Text('Error'));
              }

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  var service = services[index];

                  String tipo = service['tipo'];
                  String fecha = service['fecha'] ;
                  String pago = service['pago']!.toString();

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(tipo),
                      subtitle: Text('Date: $fecha • Paid: €$pago'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
