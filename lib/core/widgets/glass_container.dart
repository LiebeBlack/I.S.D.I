import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 28, // Bordes más orgánicos para niños
    this.padding = const EdgeInsets.all(24),
    this.blurSigma = 25, // Blur intenso para "limpiar" el fondo
  })  : assert(borderRadius >= 0, 'borderRadius cannot be negative'),
        assert(blurSigma >= 0, 'blurSigma cannot be negative');

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blurSigma;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        // Aplicamos el desenfoque intenso
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // GRADIENTE DE ALTA OPACIDAD (80%)
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // 0.8 de alpha para máxima legibilidad del texto
                Colors.white.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0.75),
              ],
            ),
            // Borde más definido para separar el contenedor del fondo
            border: Border.all(
              width: 2,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: DefaultTextStyle(
            // Forzamos un estilo de texto oscuro para que resalte sobre el blanco 80%
            style: const TextStyle(
              color: Color(0xFF1A3A5F), // Azul muy oscuro (OceanDark)
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
}
