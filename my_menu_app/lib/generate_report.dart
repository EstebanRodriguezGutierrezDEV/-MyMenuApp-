import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Reporte de Trabajo - My Menu App',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Paragraph(
            text: 'Fecha: ${DateTime.now().toString().split(' ')[0]}',
          ),
          pw.Divider(),

          _buildSection('1. Backend (Supabase)', [
            'Creacion de tablas SQL: recipes, likes, saved_recipes.',
            'Configuracion de politicas de seguridad (RLS).',
            'Storage Bucket: Creacion del bucket "recipes" para imagenes.',
          ]),

          _buildSection('2. Modelos de Datos', [
            'Recipe Model: Agregado campo "id" para interacciones.',
            'Serialization: Actualizados metodos toMap/fromMap.',
          ]),

          _buildSection('3. Servicios (RecipeService)', [
            'Implementacion de fetchRealRecipes (Feed).',
            'Logica de Likes (toggleLike, isRecipeLiked).',
            'Subida de Imagenes (uploadImage conectando con Storage).',
          ]),

          _buildSection('4. Interfaz de Usuario (UI)', [
            'My Fridge: Rediseño visual, tarjetas, y animaciones.',
            'Upload Recipe: Pantalla de subida con formulario.',
            'Camara: Integracion de image_picker para fotos de platos.',
            'Social Feed: Conexión con datos reales y likes en tiempo real.',
            'Navegacion: Enlace del boton "+" al formulario de subida.',
          ]),

          pw.Divider(),
          pw.Paragraph(text: 'Generado automaticamente por Antigravity.'),
        ];
      },
    ),
  );

  final file = File('Project_Work_Report.pdf');
  await file.writeAsBytes(await pdf.save());
  print('PDF generado exitosamente: ${file.absolute.path}');
}

pw.Widget _buildSection(String title, List<String> items) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 10),
      pw.Text(
        title,
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 5),
      ...items.map((item) => pw.Bullet(text: item)),
      pw.SizedBox(height: 10),
    ],
  );
}
