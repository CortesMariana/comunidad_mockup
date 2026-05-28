import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reels_screen.dart';
import 'notifications_screen.dart';
import 'menu_screen.dart';
import 'profile_screen.dart';
import 'crear_contenido_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeFeedScreen(),
    const ReelsScreen(),
    const NotificationsScreen(),
    MenuScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF005DB9),
          unselectedItemColor: Colors.grey[400],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.slow_motion_video_outlined), label: 'Reels'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notificaciones'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Menú'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  final List<Map<String, String>> _noticiasCarrusel = const [
    {'titulo': '📢 Nuevo proyecto 2026', 'fondo': '#005DB9'},
    {'titulo': '🎉 Fiesta de fin de año', 'fondo': '#009BDF'},
    {'titulo': '🏆 Reconocimiento al equipo', 'fondo': '#F32836'},
    {'titulo': '💻 Actualización del sistema', 'fondo': '#005DB9'},
    {'titulo': '🌟 Nuevos beneficios', 'fondo': '#009BDF'},
  ];

  final List<Map<String, String>> _historias = const [
    {'nombre': 'Mariana', 'imagen': 'https://randomuser.me/api/portraits/women/1.jpg'},
    {'nombre': 'Carlos', 'imagen': 'https://randomuser.me/api/portraits/men/1.jpg'},
    {'nombre': 'Ana', 'imagen': 'https://randomuser.me/api/portraits/women/2.jpg'},
    {'nombre': 'Luis', 'imagen': 'https://randomuser.me/api/portraits/men/2.jpg'},
    {'nombre': 'Sofia', 'imagen': 'https://randomuser.me/api/portraits/women/3.jpg'},
    {'nombre': 'Pedro', 'imagen': 'https://randomuser.me/api/portraits/men/3.jpg'},
  ];

  final List<Map<String, dynamic>> _publicaciones = const [
    {
      'usuario': 'ENERRMAX',
      'avatar': 'https://randomuser.me/api/portraits/men/4.jpg',
      'tiempo': 'Hace 2h',
      'contenido': '¡Gran noticia! Nuevo proyecto en marcha 🚀',
      'likes': 128,
      'comentarios': 34,
      'imagen': 'https://picsum.photos/id/1/400/300',
    },
    {
      'usuario': 'lunavoyager',
      'avatar': 'https://randomuser.me/api/portraits/women/4.jpg',
      'tiempo': 'Hace 5h',
      'contenido': 'Compartiendo momentos increíbles con el equipo ✨',
      'likes': 89,
      'comentarios': 12,
      'imagen': 'https://picsum.photos/id/20/400/300',
    },
    {
      'usuario': 'starryskies23',
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
      'tiempo': 'Ayer',
      'contenido': 'Capacitación exitosa hoy. Gracias a todos por participar',
      'likes': 256,
      'comentarios': 45,
      'imagen': 'https://picsum.photos/id/26/400/300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunidad Enermax', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF005DB9).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CrearContenidoScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          slivers: [
            // Carrusel de noticias (auto-scroll)
            SliverToBoxAdapter(
              child: _buildCarouselNoticias(),
            ),
            // Historias interactivas
            SliverToBoxAdapter(
              child: _buildHistorias(context),
            ),
            // Publicaciones
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPublicacionCard(context, _publicaciones[index]),
                childCount: _publicaciones.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselNoticias() {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _noticiasCarrusel.length,
        itemBuilder: (context, index) {
          final noticia = _noticiasCarrusel[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(int.parse(noticia['fondo']!.replaceFirst('#', '0xFF'))),
                  Color(int.parse(noticia['fondo']!.replaceFirst('#', '0xFF'))).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(int.parse(noticia['fondo']!.replaceFirst('#', '0xFF'))).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                noticia['titulo']!,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _mostrarHistoria(BuildContext context, Map<String, String> historia) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(historia['imagen']!),
              ),
              const SizedBox(height: 16),
              Text(
                historia['nombre']!,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hace 2 horas',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('¡Hola a todos!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Compartiendo este momento con la comunidad 💙', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorias(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Historias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _historias.length,
            itemBuilder: (context, index) {
              final historia = _historias[index];
              return GestureDetector(
                onTap: () => _mostrarHistoria(context, historia),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(historia['imagen']!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(historia['nombre']!, style: GoogleFonts.poppins(fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _mostrarOpcionesPublicacion(BuildContext context, Map<String, dynamic> publicacion) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag, color: Color(0xFFF32836)),
              title: Text('Reportar publicación', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Publicación reportada (demo)'), backgroundColor: Color(0xFFF32836)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Color(0xFF005DB9)),
              title: Text('Copiar enlace', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enlace copiado (demo)'), backgroundColor: Color(0xFF005DB9)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.grey),
              title: Text('Ocultar publicación', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicacionCard(BuildContext context, Map<String, dynamic> publicacion) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(publicacion['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(publicacion['usuario'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      Text(publicacion['tiempo'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () => _mostrarOpcionesPublicacion(context, publicacion),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(publicacion['contenido'], style: GoogleFonts.poppins(fontSize: 14)),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Image.network(
              publicacion['imagen'],
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                Text('${publicacion['likes']}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                Text('${publicacion['comentarios']}'),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}