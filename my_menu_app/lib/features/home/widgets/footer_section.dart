import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 32),
          Text(
            '© 2025 MyMenu. Todos los derechos reservados.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.text.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(
                context,
                'Privacidad',
                'Política de Privacidad',
                '''
1. Recopilación de Datos
Recopilamos información que nos proporcionas directamente (perfil, preferencias) y datos de uso para mejorar el servicio.

2. Uso de la Información
Utilizamos tus datos para personalizar menús y generar listas de compra. No vendemos tu información a terceros.

3. Seguridad
Implementamos medidas técnicas para proteger tus datos personales contra accesos no autorizados.''',
              ),
              const SizedBox(width: 24),
              _buildFooterLink(
                context,
                'Términos y Condiciones',
                'Términos de Uso',
                '''
1. Uso del Servicio
MyMenu es una herramienta de asistencia. No sustituye el consejo médico profesional.

2. Responsabilidad
El usuario es responsable de verificar los ingredientes en caso de alergias graves. MyMenu no se hace responsable de inexactitudes en la base de datos.

3. Modificaciones
Nos reservamos el derecho de modificar estos términos en cualquier momento.''',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context,
    String text,
    String title,
    String content,
  ) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              title,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Text(content, style: GoogleFonts.inter(height: 1.5)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.text.withOpacity(0.6),
          decoration: TextDecoration.underline,
          decorationColor: AppColors.text.withOpacity(0.4),
        ),
      ),
    );
  }
}
