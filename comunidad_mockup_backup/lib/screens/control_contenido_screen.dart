import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlContenidoScreen extends StatefulWidget {
  const ControlContenidoScreen({super.key});

  @override
  State<ControlContenidoScreen> createState() => _ControlContenidoScreenState();
}

class _ControlContenidoScreenState extends State<ControlContenidoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _contenidoReportado = [
    {'usuario': 'usuario123', 'tipo': 'Reel', 'motivo': 'Contenido inapropiado', 'fecha': 'Hace 2h', 'avatar': 'https://randomuser.me/api/portraits/men/20.jpg'},
    {'usuario': 'juan_perez', 'tipo': 'Comentario', 'motivo': 'Lenguaje ofensivo', 'fecha': 'Hace 5h', 'avatar': 'https://randomuser.me/api/portraits/men/21.jpg'},
    {'usuario': 'ana_garcia', 'tipo': 'Publicación', 'motivo': 'Spam', 'fecha': 'Ayer', 'avatar': 'https://randomuser.me/api/portraits/women/22.jpg'},
  ];

  final List<Map<String, dynamic>> _contenidoPendiente = [
    {'usuario': 'carlos_m', 'tipo': 'Historia', 'motivo': 'Revisión manual', 'fecha': 'Hace 3h', 'avatar': 'https://randomuser.me/api/portraits/men/23.jpg'},
    {'usuario': 'maria_l', 'tipo': 'Reel', 'motivo': 'Posible infracción', 'fecha': 'Ayer', 'avatar': 'https://randomuser.me/api/portraits/women/24.jpg'},
  ];

  final List<Map<String, dynamic>> _contenidoAprobado = [
    {'usuario': 'pedro_r', 'tipo': 'Publicación', 'motivo': 'Aprobado automáticamente', 'fecha': 'Hace 1 día', 'avatar': 'https://randomuser.me/api/portraits/men/25.jpg'},
    {'usuario': 'laura_m', 'tipo': 'Comentario', 'motivo': 'Aprobado por moderador', 'fecha': 'Hace 3 días', 'avatar': 'https://randomuser.me/api/portraits/women/26.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _aprobarContenido(Map<String, dynamic> item, int index) {
    setState(() {
      _contenidoPendiente.removeAt(index);
      _contenidoAprobado.insert(0, {
        ...item,
        'motivo': 'Aprobado por moderador',
        'fecha': 'Hace unos momentos',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contenido aprobado'), backgroundColor: Color(0xFF005DB9)),
    );
  }

  void _rechazarContenido(Map<String, dynamic> item, int index) {
    setState(() {
      _contenidoPendiente.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contenido rechazado'), backgroundColor: Color(0xFFF32836)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de contenido', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFF32836),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Reportados', icon: Icon(Icons.flag)),
            Tab(text: 'Pendientes', icon: Icon(Icons.pending)),
            Tab(text: 'Aprobados', icon: Icon(Icons.check_circle)),
          ],
          labelColor: const Color(0xFFF32836),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFF32836),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaContenido(_contenidoReportado, esReportados: true),
          _buildListaContenidoPendiente(),
          _buildListaContenido(_contenidoAprobado, esAprobados: true),
        ],
      ),
    );
  }

  Widget _buildListaContenido(List<Map<String, dynamic>> items, {bool esReportados = false, bool esAprobados = false}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(esReportados ? Icons.flag_outlined : Icons.check_circle_outline, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              esReportados ? 'No hay contenido reportado' : 'No hay contenido aprobado',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF32836), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(item['avatar']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['usuario'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          Text(item['fecha'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: esAprobados
                            ? const Color(0xFF005DB9).withOpacity(0.1)
                            : const Color(0xFFF32836).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            esAprobados ? Icons.check : Icons.error_outline,
                            size: 12,
                            color: esAprobados ? const Color(0xFF005DB9) : const Color(0xFFF32836),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            esAprobados ? 'Aprobado' : 'Reportado',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: esAprobados ? const Color(0xFF005DB9) : const Color(0xFFF32836),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.category, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('Tipo: ${item['tipo']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.report_problem, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('Motivo: ${item['motivo']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Ignorar', style: GoogleFonts.poppins(color: Colors.grey[600])),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF32836),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text('Eliminar', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
                if (!esAprobados && !esReportados) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _rechazarContenido(item, index),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Rechazar', style: GoogleFonts.poppins(color: Colors.grey[600])),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _aprobarContenido(item, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005DB9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Aprobar', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListaContenidoPendiente() {
    if (_contenidoPendiente.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pending_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay contenido pendiente'),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _contenidoPendiente.length,
      itemBuilder: (context, index) {
        final item = _contenidoPendiente[index];
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(item['avatar']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['usuario'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          Text(item['fecha'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.pending, size: 12, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            'Pendiente',
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.category, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('Tipo: ${item['tipo']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.report_problem, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('Motivo: ${item['motivo']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _rechazarContenido(item, index),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Rechazar', style: GoogleFonts.poppins(color: Colors.grey[600])),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _aprobarContenido(item, index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005DB9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text('Aprobar', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}