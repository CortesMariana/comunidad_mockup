import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Map<String, dynamic>> _publicaciones = const [
    {
      'titulo': '¡Nuevo proyecto! 🚀',
      'likes': 45,
      'comentarios': 12,
      'fecha': 'Hace 2 días',
      'imagen': 'https://picsum.photos/id/1/400/200',
    },
    {
      'titulo': 'Capacitación de seguridad',
      'likes': 32,
      'comentarios': 5,
      'fecha': 'Hace 5 días',
      'imagen': 'https://picsum.photos/id/20/400/200',
    },
    {
      'titulo': 'Bienvenida a nuevos miembros',
      'likes': 78,
      'comentarios': 23,
      'fecha': 'Hace 1 semana',
      'imagen': 'https://picsum.photos/id/26/400/200',
    },
  ];

  final List<Map<String, String>> _menciones = const [
    {'usuario': '@juan_perez', 'contenido': 'Mencionó tu publicación', 'fecha': 'Hace 3h', 'avatar': 'https://randomuser.me/api/portraits/men/30.jpg'},
    {'usuario': '@ana_garcia', 'contenido': 'Te etiquetó en un comentario', 'fecha': 'Ayer', 'avatar': 'https://randomuser.me/api/portraits/women/31.jpg'},
    {'usuario': '@carlos_m', 'contenido': 'Te menciono en una historia', 'fecha': 'Hace 2 días', 'avatar': 'https://randomuser.me/api/portraits/men/32.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Publicaciones', icon: Icon(Icons.article_outlined)),
              Tab(text: 'Menciones', icon: Icon(Icons.alternate_email)),
            ],
            labelColor: Color(0xFF005DB9),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF005DB9),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFF009BDF),
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF005DB9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mariana Cortes',
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Desarrolladora de TI',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF009BDF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ID: 0001',
                            style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF009BDF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _publicaciones.length,
                    itemBuilder: (context, index) {
                      final pub = _publicaciones[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(
                                pub['imagen']!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Center(child: Icon(Icons.broken_image, size: 40)),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pub['titulo']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildStatChip(Icons.favorite, '${pub['likes']}', const Color(0xFFF32836)),
                                      const SizedBox(width: 12),
                                      _buildStatChip(Icons.comment, '${pub['comentarios']}', const Color(0xFF009BDF)),
                                      const Spacer(),
                                      Text(pub['fecha']!, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _menciones.length,
                    itemBuilder: (context, index) {
                      final men = _menciones[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF009BDF), width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(men['avatar']!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(men['usuario']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(men['contenido']!, style: GoogleFonts.poppins(fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(men['fecha']!, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF009BDF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.reply, size: 16, color: Color(0xFF009BDF)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(count, style: GoogleFonts.poppins(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}