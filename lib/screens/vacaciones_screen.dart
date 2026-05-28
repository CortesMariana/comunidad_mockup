import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VacacionesScreen extends StatefulWidget {
  const VacacionesScreen({super.key});

  @override
  State<VacacionesScreen> createState() => _VacacionesScreenState();
}

class _VacacionesScreenState extends State<VacacionesScreen> {
  DateTime _selectedStartDate = DateTime(2026, 10, 31);
  DateTime _selectedEndDate = DateTime(2026, 11, 4);

  final List<Map<String, dynamic>> _historialSolicitudes = [
    {
      'fechaSolicitud': '15/03/2026',
      'inicio': '10/04/2026',
      'fin': '15/04/2026',
      'dias': 5,
      'status': 'Aprobado',
      'comentarios': 'Vacaciones familiares',
    },
    {
      'fechaSolicitud': '20/12/2025',
      'inicio': '05/01/2026',
      'fin': '10/01/2026',
      'dias': 5,
      'status': 'Aprobado',
      'comentarios': 'Fin de año',
    },
    {
      'fechaSolicitud': '10/10/2025',
      'inicio': '01/11/2025',
      'fin': '07/11/2025',
      'dias': 7,
      'status': 'Rechazado',
      'comentarios': 'Fechas no disponibles',
    },
  ];

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      initialDateRange: DateTimeRange(start: _selectedStartDate, end: _selectedEndDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005DB9),
              onPrimary: Colors.white,
              onSurface: Color(0xFF005DB9),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  void _mostrarFormularioSolicitud() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) {
          DateTime tempStart = _selectedStartDate;
          DateTime tempEnd = _selectedEndDate;
          String comentarios = '';

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                      'Nueva solicitud',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026, 12, 31),
                      initialDateRange: DateTimeRange(start: tempStart, end: tempEnd),
                    );
                    if (picked != null) {
                      setStateSheet(() {
                        tempStart = picked.start;
                        tempEnd = picked.end;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: const Color(0xFF005DB9)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Período solicitado', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                              Text(
                                '${tempStart.day}/${tempStart.month}/${tempStart.year} - ${tempEnd.day}/${tempEnd.month}/${tempEnd.year}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF005DB9)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Comentarios',
                    hintText: 'Motivo de las vacaciones',
                  ),
                  maxLines: 3,
                  onChanged: (value) => comentarios = value,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[600])),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final dias = tempEnd.difference(tempStart).inDays + 1;
                          setState(() {
                            _historialSolicitudes.insert(0, {
                              'fechaSolicitud': DateTime.now().toLocal().toString().split(' ')[0],
                              'inicio': '${tempStart.day}/${tempStart.month}/${tempStart.year}',
                              'fin': '${tempEnd.day}/${tempEnd.month}/${tempEnd.year}',
                              'dias': dias,
                              'status': 'Pendiente',
                              'comentarios': comentarios.isEmpty ? 'Sin comentarios' : comentarios,
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Solicitud enviada'), backgroundColor: Color(0xFF005DB9)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005DB9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Enviar', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacaciones', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF005DB9).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Color(0xFF005DB9)),
            ),
            onPressed: _mostrarFormularioSolicitud,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
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
                  'Historial de solicitudes',
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
                    '${_historialSolicitudes.length}',
                    style: TextStyle(color: const Color(0xFF005DB9), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _historialSolicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = _historialSolicitudes[index];
                final statusColor = solicitud['status'] == 'Aprobado'
                    ? const Color(0xFF005DB9)
                    : solicitud['status'] == 'Rechazado'
                    ? const Color(0xFFF32836)
                    : Colors.orange;

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
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            solicitud['status'] == 'Aprobado' ? Icons.check : Icons.pending,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${solicitud['inicio']} - ${solicitud['fin']}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${solicitud['dias']} días • Solicitado: ${solicitud['fechaSolicitud']}',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                solicitud['comentarios'],
                                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            solicitud['status'],
                            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: statusColor),
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
}