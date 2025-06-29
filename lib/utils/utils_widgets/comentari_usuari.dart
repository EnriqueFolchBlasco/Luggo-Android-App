import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';

class ComentariUsuari extends StatelessWidget {
  final String avatarRuta;
  final String nombre;
  final String ubicacion;
  final String fecha;
  final String comentario;

  const ComentariUsuari({
    super.key,
    required this.avatarRuta,
    required this.nombre,
    required this.ubicacion,
    required this.fecha,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(

            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatarRuta),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        Text(
                          ubicacion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    fecha,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            comentario,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),

          Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
        ],
      ),
    );
  }
}
