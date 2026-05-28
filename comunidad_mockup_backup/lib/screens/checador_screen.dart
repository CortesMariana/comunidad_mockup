import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChecadorScreen extends StatefulWidget {
  const ChecadorScreen({super.key});

  @override
  State<ChecadorScreen> createState() => _ChecadorScreenState();
}

class _ChecadorScreenState extends State<ChecadorScreen> {
  final List<Map<String, dynamic>> _registros = [
    {
      'fecha': '16 de Julio, 2026',
      'entrada': '09:00 AM',
      'salida': '05:10 PM',
      'total': '08:10 hrs',
      'verificado': true,
    },
    {
      'fecha': '15 de Julio, 2026',
      'entrada': '09:00 AM',
      'salida': '05:00 PM',
      'total': '08:00 hrs',
      'verificado': true,
    },
    {
      'fecha': '14 de Julio, 2026',
      'entrada': '09:15 AM',
      'salida': '05:00 PM',
      'total': '07:45 hrs',
      'verificado': false,
      'rechazadoPor': 'Llegar tarde',
    },
    {
      'fecha': '13 de Julio, 2026',
      'entrada': '09:00 AM',
      'salida': '05:00 PM',
      'total': '08:00 hrs',
      'verificado': true,
    },
  ];

  bool _isOnBreak = true;
  String _breakStatus = "Estás en receso";
  String _greeting = "¡Buenos días!";
  String _userName = "Mariana";

  Future<void> _simularCamara(String tipo) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005DB9).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tipo == 'Entrada' ? Icons.login : Icons.logout,
                    color: const Color(0xFF005DB9),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  tipo == 'Entrada' ? 'Registrar entrada' : 'Registrar salida',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF005DB9), width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 58,
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/68.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005DB9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Asegúrate de que tu cabeza esté en el círculo',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF005DB9).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Escaneando rostro...',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF005DB9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[600])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DB9),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Verificar', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final now = DateTime.now();
      final hora = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

      setState(() {
        if (tipo == 'Entrada') {
          _isOnBreak = false;
          _breakStatus = "Has iniciado tu jornada";
          _registros.insert(0, {
            'fecha': 'Hoy, ${now.day} de ${_getMonth(now.month)}',
            'entrada': hora,
            'salida': 'Pendiente',
            'total': '-- hrs',
            'verificado': true,
          });
        } else {
          _isOnBreak = true;
          _breakStatus = "Jornada finalizada";
          if (_registros[0]['salida'] == 'Pendiente') {
            _registros[0]['salida'] = hora;
            // Calcular horas trabajadas
            _registros[0]['total'] = _calcularHoras(_registros[0]['entrada'], hora);
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tipo == 'Entrada' ? 'Entrada registrada' : 'Salida registrada'),
          backgroundColor: const Color(0xFF005DB9),
        ),
      );
    }
  }

  String _calcularHoras(String entrada, String salida) {
    // Simplificación para demo
    return "08:00 hrs";
  }

  String _getMonth(int month) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Checador', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha actual
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Color(0xFF005DB9)),
                  const SizedBox(width: 8),
                  Text(
                    _getFormattedDate(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF009BDF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 14, color: Color(0xFF009BDF)),
                        const SizedBox(width: 4),
                        Text('Filtrar', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF009BDF))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tarjeta principal de estado
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF005DB9).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userName,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isOnBreak ? Colors.orange : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _isOnBreak ? "En receso" : "En jornada",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Hora actual
                      Column(
                        children: [
                          Text(
                            _getCurrentTime(),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '03:00 hrs restantes',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _simularCamara('Entrada'),
                          icon: const Icon(Icons.login, size: 18),
                          label: Text('ENTRADA', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF005DB9),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _simularCamara('Salida'),
                          icon: const Icon(Icons.logout, size: 18),
                          label: Text('SALIDA', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF009BDF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Totales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                          Text('Horas trabajadas', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                          Text('Hoy', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
                          const SizedBox(height: 8),
                          Text('00:00', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF005DB9))),
                          Text('hrs', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                          Text('Horas trabajadas', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                          Text('Período actual', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
                          const SizedBox(height: 8),
                          Text('45:56', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF005DB9))),
                          Text('hrs', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Período actual
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Período actual',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '01-31 Julio, 2026',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF009BDF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16, color: Color(0xFF009BDF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Historial de registros
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final registro = _registros[index];
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
                            Text(
                              registro['fecha'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const Spacer(),
                            Text(
                              '${registro['total']} total hrs',
                              style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF005DB9), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF009BDF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                registro['entrada'],
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF009BDF)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF32836).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                registro['salida'],
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFF32836)),
                              ),
                            ),
                            const Spacer(),
                            if (registro['verificado'] == true)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 14, color: Colors.green),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.red),
                              ),
                          ],
                        ),
                        if (registro['verificado'] == false && registro.containsKey('rechazadoPor'))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Incidencia por: ${registro['rechazadoPor']}',
                                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${_getMonth(now.month)} ${now.day}, ${now.year}';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}