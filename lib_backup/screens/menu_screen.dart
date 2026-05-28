import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checador_screen.dart';
import 'vacaciones_screen.dart';
import 'permisos_screen.dart';
import 'uniformes_screen.dart';
import 'desempeno_screen.dart';
import 'solicitud_vacantes_screen.dart';
import 'control_contenido_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.access_time_filled,
      'title': 'Checador',
      'subtitle': 'Registro de entradas',
      'color': '005DB9',
      'screen': const ChecadorScreen(),
    },
    {
      'icon': Icons.beach_access,
      'title': 'Vacaciones',
      'subtitle': 'Solicitar días',
      'color': '009BDF',
      'screen': const VacacionesScreen(),
    },
    {
      'icon': Icons.event_note,
      'title': 'Permisos',
      'subtitle': 'Ausencias justificadas',
      'color': '005DB9',
      'screen': PermisosScreen(),
    },
    {
      'icon': Icons.checkroom,
      'title': 'Uniformes',
      'subtitle': 'Solicitud de ropa',
      'color': '009BDF',
      'screen': const UniformesScreen(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Desempeño',
      'subtitle': 'Métricas y ranking',
      'color': '005DB9',
      'screen': const DesempenoScreen(),
    },
    {
      'icon': Icons.work_outline,
      'title': 'Solicitud de vacantes',
      'subtitle': 'Pedir personal',
      'color': '009BDF',
      'screen': SolicitudVacantesScreen(),
    },
    {
      'icon': Icons.admin_panel_settings,
      'title': 'Control de contenido',
      'subtitle': 'Moderación',
      'color': 'F32836',
      'screen': const ControlContenidoScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Bienvenido 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Mariana Cortes',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Desarrolladora de TI',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return _buildMenuCard(context, item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    final Color color = Color(int.parse('0xFF${item['color']}'));
    final Color lightColor = color.withOpacity(0.1);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item['screen']),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  item['icon'],
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item['subtitle'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}