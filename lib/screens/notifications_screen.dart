import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> _notificaciones = const [
    {'usuario': 'starryskies23', 'accion': 'Me gustó tu publicación', 'tiempo': '1d', 'avatar': 'https://randomuser.me/api/portraits/women/10.jpg'},
    {'usuario': 'emberecho', 'accion': 'Me gustó tu publicación', 'tiempo': '2d', 'avatar': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'usuario': 'lunavoyager', 'accion': 'Te mencione en mi pucblicación', 'tiempo': '3d', 'avatar': 'https://randomuser.me/api/portraits/women/12.jpg'},
    {'usuario': 'shadowlynx', 'accion': 'Comente tu publicación: Felicidades!!', 'tiempo': '4d', 'avatar': 'https://randomuser.me/api/portraits/men/13.jpg'},
    {'usuario': 'nebulanomad', 'accion': 'Te mencione en mi comentario', 'tiempo': '5d', 'avatar': 'https://randomuser.me/api/portraits/women/14.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF005DB9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Activity',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildNotificationCard(_notificaciones[index]),
              childCount: _notificaciones.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> notif) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFF005DB9).withOpacity(0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF009BDF), width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(notif['avatar']!),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: notif['usuario'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${notif['accion']}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        notif['tiempo']!,
                        style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFF32836),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}