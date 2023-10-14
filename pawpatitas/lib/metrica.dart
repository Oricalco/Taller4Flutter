import 'package:flutter/material.dart';
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
  final List<AdopcionPorRaza> adopcionData = [
    AdopcionPorRaza('Labrador', 23, Colors.yellow),
    AdopcionPorRaza('Bulldog', 10, Colors.green),
    AdopcionPorRaza('Beagle', 15, Colors.blue),
    AdopcionPorRaza('Poodle', 8, Colors.red),
    AdopcionPorRaza('Chihuahua', 20, Colors.purple),
    AdopcionPorRaza('Husky', 18, Colors.orange),
  ];

  final List<IngresoPorFecha> ingresoData = [
    IngresoPorFecha('2023-10-01', 5),
    IngresoPorFecha('2023-10-02', 8),
    IngresoPorFecha('2023-10-03', 10),
    IngresoPorFecha('2023-10-04', 12),
    IngresoPorFecha('2023-10-05', 6),
  ];

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
    return Center(
      child: SfCircularChart(
        series: <PieSeries<AdopcionPorRaza, String>>[
          PieSeries<AdopcionPorRaza, String>(
            dataSource: adopcionData,
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
  }

  Widget _buildIngresoChart() {
    return Center(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<IngresoPorFecha, String>>[
          ColumnSeries<IngresoPorFecha, String>(
            dataSource: ingresoData,
            xValueMapper: (IngresoPorFecha data, _) => data.fecha,
            yValueMapper: (IngresoPorFecha data, _) => data.ingresos,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaginaMetricas(),
  ));
}
