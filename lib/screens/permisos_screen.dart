import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PermisosScreen extends StatelessWidget {
  PermisosScreen({super.key});

  final List<Map<String, String>> _permisos = const [
    {'motivo': 'Cita médica 🏥', 'fecha': 'Viernes 31, Octubre del 2026', 'dias': '0', 'status': 'Pendiente'},
    {'motivo': 'Permiso personal', 'fecha': 'Lunes 30, Marzo del 2026', 'dias': '0', 'status': 'Aprobado'},
    {'motivo': 'Trámite bancario', 'fecha': 'Martes 7, Abril del 2026', 'dias': '0', 'status': 'Aprobado'},
    {'motivo': 'Cita médica', 'fecha': 'Miércoles 8, Abril del 2026', 'dias': '0', 'status': 'Rechazado'},
    {'motivo': 'Permiso', 'fecha': 'Jueves 9, Abril del 2026', 'dias': '0', 'status': 'Pendiente'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permisos', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _mostrarDialogoSolicitud(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('NUEVO PERMISO', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white )),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009BDF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  'Mis solicitudes',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005DB9).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.list_alt, size: 20, color: Color(0xFF005DB9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _permisos.length,
              itemBuilder: (context, index) {
                final permiso = _permisos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF009BDF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.event_note, color: const Color(0xFF009BDF)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(permiso['motivo']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(permiso['fecha']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                              Text('Días solicitados: ${permiso['dias']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(permiso['status']!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            permiso['status']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(permiso['status']!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprobado':
        return const Color(0xFF005DB9);
      case 'Rechazado':
        return const Color(0xFFF32836);
      default:
        return Colors.orange;
    }
  }

  void _mostrarDialogoSolicitud(BuildContext context) {
    final motivoController = TextEditingController();
    final horaInicio = TimeOfDay.now();
    final horaFin = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Solicitar permiso', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: motivoController,
              decoration: InputDecoration(
                labelText: 'Motivo',
                hintText: 'Ej: Cita médica, trámite, etc.',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton('Hora inicio', horaInicio),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeButton('Hora fin', horaFin),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Solicitud enviada (demo)'), backgroundColor: Color(0xFF005DB9)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005DB9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Enviar', style: GoogleFonts.poppins(color: Colors.white )),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF005DB9).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF005DB9).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 16, color: const Color(0xFF005DB9)),
              const SizedBox(width: 8),
              Text(
                '${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'am' : 'pm'}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}