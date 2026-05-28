import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SolicitudVacantesScreen extends StatelessWidget {
  SolicitudVacantesScreen({super.key});

  final List<Map<String, String>> _solicitudesPendientes = const [
    {'puesto': 'Desarrollador Flutter', 'area': 'Tecnología', 'urgente': 'Sí', 'fecha': '25/04/2026'},
    {'puesto': 'Community Manager', 'area': 'Marketing', 'urgente': 'No', 'fecha': '28/04/2026'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar personal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, const Color(0xFF005DB9).withOpacity(0.03)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.people_outline, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Solicitar nuevo personal',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Puesto solicitado',
                        hintText: 'Ej: Desarrollador Flutter',
                        prefixIcon: const Icon(Icons.work_outline, color: Color(0xFF005DB9)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Área / Departamento',
                        hintText: 'Ej: Tecnología',
                        prefixIcon: const Icon(Icons.business, color: Color(0xFF005DB9)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad de personas',
                        hintText: '1',
                        prefixIcon: const Icon(Icons.people, color: Color(0xFF005DB9)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Justificación',
                        hintText: 'Describir por qué se necesita el puesto',
                        prefixIcon: const Icon(Icons.description, color: Color(0xFF005DB9)),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: null,
                            activeColor: const Color(0xFFF32836),
                          ),
                          Text(
                            'Marcar como urgente',
                            style: GoogleFonts.poppins(color: const Color(0xFFF32836)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Solicitud enviada a RH (demo)'), backgroundColor: Color(0xFF005DB9)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005DB9),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Enviar solicitud', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    'Solicitudes pendientes',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005DB9).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_solicitudesPendientes.length}',
                      style: TextStyle(color: const Color(0xFF005DB9), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final solicitud = _solicitudesPendientes[index];
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
                          child: const Icon(Icons.pending_actions, color: Color(0xFF009BDF)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(solicitud['puesto']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              Text('${solicitud['area']} • ${solicitud['fecha']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: solicitud['urgente'] == 'Sí'
                                ? const Color(0xFFF32836).withOpacity(0.1)
                                : const Color(0xFF009BDF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            solicitud['urgente'] == 'Sí' ? 'Urgente' : 'Normal',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: solicitud['urgente'] == 'Sí'
                                  ? const Color(0xFFF32836)
                                  : const Color(0xFF009BDF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _solicitudesPendientes.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}