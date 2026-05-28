import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrearContenidoScreen extends StatefulWidget {
  const CrearContenidoScreen({super.key});

  @override
  State<CrearContenidoScreen> createState() => _CrearContenidoScreenState();
}

class _CrearContenidoScreenState extends State<CrearContenidoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _descripcionController = TextEditingController();
  String _categoriaReel = 'Cultura';

  // Banner programable
  DateTime _fechaInicioBanner = DateTime.now();
  DateTime _fechaFinBanner = DateTime.now().add(const Duration(days: 7));
  String _tituloBanner = '';
  String _mensajeBanner = '';
  bool _bannerActivo = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFechas() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _fechaInicioBanner, end: _fechaFinBanner),
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
        _fechaInicioBanner = picked.start;
        _fechaFinBanner = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear contenido', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Publicación', icon: Icon(Icons.post_add)),
            Tab(text: 'Reel', icon: Icon(Icons.slow_motion_video)),
            Tab(text: 'Historia', icon: Icon(Icons.history)),
          ],
          labelColor: const Color(0xFF005DB9),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF005DB9),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFormularioPublicacion(),
          _buildFormularioReel(),
          _buildFormularioHistoria(),
        ],
      ),
    );
  }

  Widget _buildFormularioPublicacion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Banner programable
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.ads_click, color: const Color(0xFF005DB9)),
                      const SizedBox(width: 8),
                      Text(
                        'Banner destacado',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('Activar banner', style: GoogleFonts.poppins()),
                    value: _bannerActivo,
                    onChanged: (value) {
                      setState(() {
                        _bannerActivo = value;
                      });
                    },
                    activeColor: const Color(0xFF005DB9),
                  ),
                  if (_bannerActivo) ...[
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Título del banner',
                        hintText: 'Ej: Promoción especial',
                      ),
                      onChanged: (value) => _tituloBanner = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Mensaje',
                        hintText: 'Texto que aparecerá en el banner',
                      ),
                      maxLines: 2,
                      onChanged: (value) => _mensajeBanner = value,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _seleccionarFechas,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
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
                                  Text('Fecha de publicación', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                                  Text(
                                    '${_fechaInicioBanner.day}/${_fechaInicioBanner.month}/${_fechaInicioBanner.year} - ${_fechaFinBanner.day}/${_fechaFinBanner.month}/${_fechaFinBanner.year}',
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(68),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _tituloBanner.isEmpty ? 'Vista previa del banner' : _tituloBanner,
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _mensajeBanner.isEmpty ? 'Tu mensaje aquí' : _mensajeBanner,
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Válido hasta: ${_fechaFinBanner.day}/${_fechaFinBanner.month}',
                              style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF005DB9).withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, size: 48, color: const Color(0xFF005DB9).withOpacity(0.5)),
                const SizedBox(height: 8),
                Text('Subir imagen', style: GoogleFonts.poppins(color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: '¿Qué estás pensando?',
              hintText: 'Comparte algo con tu comunidad...',
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Publicación creada (demo)'), backgroundColor: Color(0xFF005DB9)),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005DB9),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Publicar', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioReel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[900]!, Colors.grey[800]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library, size: 60, color: Colors.white54),
                const SizedBox(height: 12),
                Text('Seleccionar video', style: GoogleFonts.poppins(color: Colors.white54)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: 'Título del reel',
              hintText: 'Dale un nombre a tu reel',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _categoriaReel,
            decoration: const InputDecoration(
              labelText: 'Categoría',
            ),
            items: const [
              DropdownMenuItem(value: 'Cultura', child: Text('🎉 Cultura')),
              DropdownMenuItem(value: 'Anuncios', child: Text('📢 Anuncios')),
              DropdownMenuItem(value: 'Capacitación', child: Text('📚 Capacitación')),
            ],
            onChanged: (value) {
              setState(() {
                _categoriaReel = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reel subido (demo)'), backgroundColor: Color(0xFFF32836)),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF32836),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Subir reel', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioHistoria() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF005DB9), Color(0xFF009BDF)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 60, color: Colors.white.withOpacity(0.9)),
                const SizedBox(height: 12),
                Text('Tomar foto / video', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Disponible por 24 horas', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: 'Texto de la historia',
              hintText: 'Opcional',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Historia publicada (demo)'), backgroundColor: Color(0xFF009BDF)),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009BDF),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Compartir historia', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}