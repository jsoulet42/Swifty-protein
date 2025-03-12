// lib/widgets/molecule_3d_painter.dart
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../models/atom.dart';
import '../models/bond.dart';

class Molecule3DPainter extends CustomPainter {
  final List<Atom> atoms;
  final List<Bond> bonds;
  final double rotationX; // en radians
  final double rotationY; // en radians
  final double zoom; // facteur de zoom

  Molecule3DPainter({
    required this.atoms,
    required this.bonds,
    required this.rotationX,
    required this.rotationY,
    required this.zoom,
  });

  // Map de couleurs CPK pour chaque type d'atome
  final Map<String, Color> _atomColors = const {
    'C': Colors.grey, // Carbone
    'H': Colors.white, // Hydrogène
    'O': Colors.red, // Oxygène
    'N': Colors.blue, // Azote
    'S': Colors.yellow, // Soufre
    'P': Colors.orange, // Phosphore
    // Ajouter d'autres types si nécessaire
  };

  @override
  void paint(Canvas canvas, Size size) {
    // Créer et configurer la matrice 3D pour la transformation
    final matrix =
        vm.Matrix4.identity()
          ..translate(size.width / 2, size.height / 2, 0)
          ..scale(zoom, zoom, zoom)
          ..rotateX(rotationX)
          ..rotateY(rotationY);

    // Distance de la caméra pour la perspective
    const double perspective = 400.0;

    // Fonction de projection 3D -> 2D
    Offset project(vm.Vector3 point) {
      final vm.Vector3 transformed = matrix.transform3(point);
      final double factor = perspective / (perspective + transformed.z);
      return Offset(transformed.x * factor, transformed.y * factor);
    }

    // Dessiner les liaisons en noir (ou gris foncé)
    final Paint bondPaint =
        Paint()
          ..color = const Color.fromARGB(221, 82, 80, 80)
          ..strokeWidth = 2.0;
    for (var bond in bonds) {
      final Atom atom1 = atoms[bond.startAtomId];
      final Atom atom2 = atoms[bond.endAtomId];
      final Offset p1 = project(vm.Vector3(atom1.x, atom1.y, atom1.z));
      final Offset p2 = project(vm.Vector3(atom2.x, atom2.y, atom2.z));
      canvas.drawLine(p1, p2, bondPaint);
    }

    // Dessiner les atomes avec leur couleur CPK
    for (var atom in atoms) {
      final Offset pos = project(vm.Vector3(atom.x, atom.y, atom.z));
      // Récupérer la couleur correspondant au type d'atome ; par défaut, utiliser une couleur violette
      final Color color = _atomColors[atom.type] ?? Colors.purple;
      final Paint atomPaint = Paint()..color = color;

      // Définir un rayon pour l'atome (vous pouvez adapter selon le type)
      const double radius = 5.0;
      canvas.drawCircle(pos, radius, atomPaint);
    }
  }

  @override
  bool shouldRepaint(covariant Molecule3DPainter oldDelegate) {
    return oldDelegate.atoms != atoms ||
        oldDelegate.bonds != bonds ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.zoom != zoom;
  }
}
