import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/atom.dart';
import '../models/bond.dart';
import '../models/ligand_detail.dart';
import '../services/rcsb_api_service.dart';
import '../services/pdb_parser.dart';
import '../utils/logger.dart';
import '../widgets/interactive_molecule_view.dart';

class Molecule3DViewScreen extends StatefulWidget {
  final String ligandCode;

  const Molecule3DViewScreen({super.key, required this.ligandCode});

  @override
  State<Molecule3DViewScreen> createState() => _Molecule3DViewScreenState();
}

class _Molecule3DViewScreenState extends State<Molecule3DViewScreen>
    with WidgetsBindingObserver {
  List<Atom>? atoms;
  List<Bond>? bonds;
  bool isLoading = true;
  String? errorMessage;
  String? sdfContent;
  LigandDetail? ligandDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSDF();
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
        "Application revenue au premier plan - rechargement du modèle 3D",
        tag: "APP_LIFECYCLE",
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _loadSDF();
        }
      });
    }
  }

  Future<void> _loadSDF() async {
    try {
      LigandDetail detail = await RcsbApiService.fetchLigandDetailFromChemcomp(
        widget.ligandCode,
      );
      if (!mounted) return;

      sdfContent = await RcsbApiService.fetchIdealSdfFile(widget.ligandCode);
      Logger.log(
        "Contenu téléchargé du fichier SDF: ${sdfContent!.substring(0, 100)}...",
      );

      List<Atom> atomsParsed = SdfParser.parseAtoms(sdfContent!);
      List<Bond> bondsParsed = SdfParser.parseBonds(sdfContent!);

      if (!mounted) return;
      setState(() {
        ligandDetail = detail;
        atoms = atomsParsed;
        bonds = bondsParsed;
        isLoading = false;
      });
    } catch (e) {
      Logger.log(
        "Erreur lors du téléchargement du fichier SDF: $e",
        tag: "Molecule3DViewScreen",
      );
      if (!mounted) return;
      setState(() {
        errorMessage = "Erreur: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Visualisation 3D: ${widget.ligandCode}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      // IMAGE DE FOND
                      Positioned.fill(
                        child: Image.asset(
                          "assets/imagebackG.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      // EFFET SHIMMER (sans withOpacity)
                      Positioned.fill(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(
                                    10,
                                  ), // Effet de lumière
                                  Colors.grey[300]!,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : InteractiveMoleculeView(
                atoms: atoms!,
                bonds: bonds!,
                ligandDetail: ligandDetail!,
              ),
    );
  }
}
