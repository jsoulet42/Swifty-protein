import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/atom.dart';
import '../models/bond.dart';
import '../models/ligand_detail.dart';
import '../screens/molecule_3d_painter.dart';
import '../utils/logger.dart';

class InteractiveMoleculeView extends StatefulWidget {
  final List<Atom> atoms;
  final List<Bond> bonds;
  final LigandDetail ligandDetail;

  const InteractiveMoleculeView({
    super.key,
    required this.atoms,
    required this.bonds,
    required this.ligandDetail,
  });

  @override
  State<InteractiveMoleculeView> createState() =>
      _InteractiveMoleculeViewState();
}

class _InteractiveMoleculeViewState extends State<InteractiveMoleculeView>
    with WidgetsBindingObserver {
  final double _rotationX = 0;
  double _rotationY = 0;
  double _zoom = 10.0;
  bool _showTooltip = false;
  bool _isRefreshing = false; // Ajout d'un indicateur de rafraîchissement
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  final double _zoomIncrement = 0.7;
  final double _rotationIncrement = 0.1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Logger.log(
        "Application revenue au premier plan - rafraîchissement du rendu 3D",
        tag: "APP_LIFECYCLE",
      );
      _refreshView();
    }
  }

  void _refreshView() {
    if (!mounted) return;
    setState(() {
      _isRefreshing = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    });
  }

  void _toggleTooltip() {
    setState(() {
      _showTooltip = !_showTooltip;
    });
  }

  void _zoomIn() {
    setState(() {
      _zoom += _zoomIncrement;
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom - _zoomIncrement).clamp(0.1, double.infinity);
    });
  }

  void _rotateLeft() {
    setState(() {
      _rotationY -= _rotationIncrement;
    });
  }

  void _rotateRight() {
    setState(() {
      _rotationY += _rotationIncrement;
    });
  }

  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          _repaintBoundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/molecule.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(filePath),
      ], text: "Regardez ce modèle 3D !");
    } catch (e) {
      Logger.log("Erreur lors de la capture et du partage : $e", tag: "SHARE");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _toggleTooltip,
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child:
                      _isRefreshing
                          ? const Center(child: CircularProgressIndicator())
                          : CustomPaint(
                            size: Size.infinite,
                            painter: Molecule3DPainter(
                              atoms: widget.atoms,
                              bonds: widget.bonds,
                              rotationX: _rotationX,
                              rotationY: _rotationY,
                              zoom: _zoom,
                            ),
                          ),
                ),
              ),
              if (_showTooltip)
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Material(
                    color: Colors.black.withAlpha((0.7 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Code: ${widget.ligandDetail.chemCompId}\n'
                        'Nom: ${widget.ligandDetail.name}\n'
                        'Formule: ${widget.ligandDetail.formula}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              ElevatedButton(
                onPressed: _rotateLeft,
                child: const Text("Rot. Gauche"),
              ),
              ElevatedButton(
                onPressed: _rotateRight,
                child: const Text("Rot. Droite"),
              ),
              ElevatedButton(onPressed: _zoomIn, child: const Text("Zoom +")),
              ElevatedButton(onPressed: _zoomOut, child: const Text("Zoom -")),
              ElevatedButton(
                onPressed: _captureAndShare,
                child: const Text("Partager 📤"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
