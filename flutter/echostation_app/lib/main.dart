import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Echostation",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans'),
      home: const HomePage(),
    );
  }
}

class Bat {
  final String id;
  final String name;
  final String image;
  final String info;
  final String soundType;

  Bat({
    required this.id,
    required this.name,
    required this.image,
    required this.info,
    required this.soundType,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentId;

  final List<Bat> bats = [
    Bat(
      id: "bat1",
      name: "Lasionycteris noctivagans",
      image: "assets/images/Lasionycteris noctivagans.png",
      info: "Silver-haired bat with low-frequency echolocation calls.",
      soundType: "Echolocation",
    ),
    Bat(
      id: "bat2",
      name: "Long-legged Myotis",
      image: "assets/images/Long-legged Myotis.png",
      info: "Rapid high-frequency chirps while foraging.",
      soundType: "Echolocation",
    ),
    Bat(
      id: "bat3",
      name: "Nyctalus noctula",
      image: "assets/images/Nyctalus noctula.png",
      info: "Known for loud, low-pitched calls.",
      soundType: "Echolocation",
    ),
    Bat(
      id: "bat4",
      name: "Rhinolophus",
      image: "assets/images/Rhinolophus.png",
      info: "Uses constant frequency calls for precise hunting.",
      soundType: "Echolocation",
    ),
    Bat(
      id: "bat5",
      name: "Pipistrellus pipistrella",
      image: "assets/images/Pipistrellus pipistrella.png",
      info: "Tiny bat with fast, high-pitched calls.",
      soundType: "Echolocation",
    ),
  ];

  void _togglePlay(Bat bat) async {
    if (_currentId == bat.id) {
      await _player.stop();
      setState(() => _currentId = null);
      return;
    }

    await _player.stop();
    await _player.play(AssetSource("mp3/${bat.id}.mp3"));
    setState(() => _currentId = bat.id);

    _player.onPlayerComplete.listen((_) {
      setState(() => _currentId = null);
    });
  }

  void _showInfo(Bat bat) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bat.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(bat.info, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Text("Sound type: ${bat.soundType}",
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/logo.svg", height: 28),
                  const SizedBox(width: 8),
                  const Text("SMACON's Echostation",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFFE97101))),
                ],
              ),
            ),

            // Description
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Explore the unique calls of different bat species",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: bats.length,
                itemBuilder: (context, index) {
                  final bat = bats[index];
                  return Stack(
                    children: [
                      // Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.asset(bat.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity),
                            Container(
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),

                      // Info icon top-right
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _showInfo(bat),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/info_icon.svg",
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ),

                      // Title & play button
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(bat.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              GestureDetector(
                                onTap: () => _togglePlay(bat),
                                child: SvgPicture.asset(
                                  _currentId == bat.id
                                      ? "assets/icons/pause_circle.svg"
                                      : "assets/icons/play_circle.svg",
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Footer
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text("© SMACON 2025",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}