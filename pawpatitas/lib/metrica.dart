import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdopcionPorRaza {
  final String raza;
  final int adopciones;
  final Color color;

  AdopcionPorRaza(this.raza, this.adopciones, this.color);
}

class IngresoPorFecha {
  final String fecha;
  final int ingresos;

  IngresoPorFecha(this.fecha, this.ingresos);
}

class PaginaMetricas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Métricas de Adopción e Ingresos'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Adopciones'),
              Tab(text: 'Ingresos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAdopcionChart(),
            _buildIngresoChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdopcionChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('animales').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data?.docs;
        if (data == null || data.isEmpty) {
          return Center(
            child: Text('No hay datos disponibles en la colección "animales"'),
          );
        }

        return Center(
          child: SfCircularChart(
            series: <PieSeries<AdopcionPorRaza, String>>[
              PieSeries<AdopcionPorRaza, String>(
                dataSource: _generateAdoptionData(data),
                xValueMapper: (AdopcionPorRaza data, _) => data.raza,
                yValueMapper: (AdopcionPorRaza data, _) => data.adopciones,
                dataLabelMapper: (AdopcionPorRaza data, _) =>
                    '${data.raza}: ${data.adopciones}',
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<AdopcionPorRaza> _generateAdoptionData(
      List<QueryDocumentSnapshot> data) {
    final Map<String, int> razaAdopciones = {};

    data.forEach((document) {
      final raza = document['raza'] as String;
      razaAdopciones[raza] = (razaAdopciones[raza] ?? 0) + 1;
    });

    return razaAdopciones.entries.map((entry) {
      final raza = entry.key;
      final adopciones = entry.value;
      final color = Colors.blue;
      return AdopcionPorRaza(raza, adopciones, color);
    }).toList();
  }

  Widget _buildIngresoChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('animales').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data?.docs;
        if (data == null || data.isEmpty) {
          return Center(
            child: Text('No hay datos disponibles en la colección "animales"'),
          );
        }

        return Center(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ColumnSeries<IngresoPorFecha, String>>[
              ColumnSeries<IngresoPorFecha, String>(
                dataSource: _generateIngresoData(data),
                xValueMapper: (IngresoPorFecha data, _) => data.fecha,
                yValueMapper: (IngresoPorFecha data, _) => data.ingresos,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        );
      },
    );
  }

  List<IngresoPorFecha> _generateIngresoData(List<QueryDocumentSnapshot> data) {
    final Map<DateTime, int> fechaIngresos = {};

    data.forEach((document) {
      final timestamp = document['fecha_ingreso'] as Timestamp;
      final date = timestamp.toDate();

      final formattedDate = DateTime(date.year, date.month);

      fechaIngresos[formattedDate] = (fechaIngresos[formattedDate] ?? 0) + 1;
    });

    final sortedEntries = fechaIngresos.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries.map((entry) {
      final fecha = entry.key;
      final ingresos = entry.value;

      final formattedDate =
          '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';

      return IngresoPorFecha(formattedDate, ingresos);
    }).toList();
  }
}

void main() {
  runApp(MaterialApp(
    home: PaginaMetricas(),
  ));
}
