import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class UniformesScreen extends StatefulWidget {
  const UniformesScreen({super.key});

  @override
  State<UniformesScreen> createState() => _UniformesScreenState();
}

class _UniformesScreenState extends State<UniformesScreen> {
  final List<Map<String, dynamic>> _catalogoUniformes = [
    {'nombre': 'Camisa formal', 'imagen': '👕', 'tallasDisponibles': ['S', 'M', 'L', 'XL'], 'coloresDisponibles': ['Negra', 'Blanca', 'Azul']},
    {'nombre': 'Pantalón', 'imagen': '👖', 'tallasDisponibles': ['30', '32', '34', '36'], 'coloresDisponibles': ['Negro', 'Gris', 'Azul']},
    {'nombre': 'Chaleco', 'imagen': '🧥', 'tallasDisponibles': ['S', 'M', 'L', 'XL'], 'coloresDisponibles': ['Negro', 'Azul']},
    {'nombre': 'Gorra', 'imagen': '🧢', 'tallasDisponibles': ['Única'], 'coloresDisponibles': ['Negra', 'Azul']},
    {'nombre': 'Chamarra', 'imagen': '🧥', 'tallasDisponibles': ['S', 'M', 'L', 'XL'], 'coloresDisponibles': ['Negra', 'Azul']},
  ];

  List<Map<String, dynamic>> _carrito = [];
  List<Map<String, dynamic>> _historialPedidos = [
    {'fecha': '15/03/2026', 'items': ['Camisa formal (M, Negra)', 'Pantalón (32, Negro)'], 'status': 'Entregado'},
    {'fecha': '10/01/2026', 'items': ['Chaleco (L, Azul)'], 'status': 'Entregado'},
    {'fecha': '05/12/2025', 'items': ['Gorra (Única, Negra)'], 'status': 'Entregado'},
  ];

  String _tallaSeleccionada = 'M';
  String _colorSeleccionado = 'Negra';
  int? _productoSeleccionado;

  void _agregarAlCarrito(Map<String, dynamic> producto) {
    setState(() {
      _carrito.add({
        'nombre': producto['nombre'],
        'talla': _tallaSeleccionada,
        'color': _colorSeleccionado,
        'imagen': producto['imagen'],
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto['nombre']} agregado al carrito'), backgroundColor: const Color(0xFF005DB9)),
    );
  }

  void _mostrarCarrito() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
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
                      'Mi carrito (${_carrito.length})',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_carrito.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('Carrito vacío', style: GoogleFonts.poppins(color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  )
                else ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: _carrito.length,
                      itemBuilder: (context, index) {
                        final item = _carrito[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: Text(item['imagen'], style: const TextStyle(fontSize: 30)),
                            title: Text(item['nombre'], style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                            subtitle: Text('Talla: ${item['talla']} • Color: ${item['color']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFF32836)),
                              onPressed: () {
                                setStateSheet(() {
                                  _carrito.removeAt(index);
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _historialPedidos.insert(0, {
                          'fecha': DateTime.now().toLocal().toString().split(' ')[0],
                          'items': _carrito.map((e) => '${e['nombre']} (${e['talla']}, ${e['color']})').toList(),
                          'status': 'Pendiente',
                        });
                        _carrito.clear();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solicitud enviada'), backgroundColor: Color(0xFF005DB9)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DB9),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Solicitar (${_carrito.length} items)', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _mostrarSelector(String nombre, List<String> tallas, List<String> colores, Map<String, dynamic> producto) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) {
          String tallaTemp = tallas[0];
          String colorTemp = colores[0];

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(nombre, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: tallaTemp,
                  decoration: const InputDecoration(labelText: 'Talla'),
                  items: tallas.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setStateSheet(() => tallaTemp = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: colorTemp,
                  decoration: const InputDecoration(labelText: 'Color'),
                  items: colores.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setStateSheet(() => colorTemp = v!),
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
                          _tallaSeleccionada = tallaTemp;
                          _colorSeleccionado = colorTemp;
                          _agregarAlCarrito(producto);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005DB9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Agregar', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
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
        title: Text('Uniformes', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: _mostrarCarrito,
              ),
              if (_carrito.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF32836),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_carrito.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Catálogo', icon: Icon(Icons.checkroom)),
                Tab(text: 'Historial', icon: Icon(Icons.history)),
              ],
              labelColor: Color(0xFF005DB9),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF005DB9),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCatalogo(),
                  _buildHistorial(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: _catalogoUniformes.length,
        itemBuilder: (context, index) {
          final uniforme = _catalogoUniformes[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF005DB9).withOpacity(0.1), const Color(0xFF009BDF).withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Center(
                    child: Text(uniforme['imagen'], style: const TextStyle(fontSize: 50)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(uniforme['nombre'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: (uniforme['tallasDisponibles'] as List).map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t, style: GoogleFonts.poppins(fontSize: 10)),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _mostrarSelector(
                            uniforme['nombre'],
                            uniforme['tallasDisponibles'],
                            uniforme['coloresDisponibles'],
                            uniforme,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005DB9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text('Agregar', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistorial() {
    if (_historialPedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No hay pedidos anteriores', style: GoogleFonts.poppins(color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historialPedidos.length,
      itemBuilder: (context, index) {
        final pedido = _historialPedidos[index];
        final statusColor = pedido['status'] == 'Entregado'
            ? const Color(0xFF005DB9)
            : Colors.orange;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        pedido['status'] == 'Entregado' ? Icons.check : Icons.pending,
                        color: statusColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pedido del ${pedido['fecha']}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pedido['status'],
                        style: GoogleFonts.poppins(fontSize: 10, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...(pedido['items'] as List).map((item) => Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 4),
                  child: Text('• $item', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}