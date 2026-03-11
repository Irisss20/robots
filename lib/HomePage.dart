import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled4/robot.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Robot red1;
  late Robot yellow2;

  String winner = "Who will win ?";

  // States
  bool showLotties = false;
  bool showStaticImages = true;
  bool fireRed1 = false, fireRed2 = false;
  bool fireYellow1 = false, fireYellow2 = false;
  bool lotty2Visible = false, lotty2dVisible = false;
  bool isGameOver = false;
  bool isGameStarted = false;

  // Исправил: теперь это строка для текста победы
  String currentWinnerText = "";

  @override
  void initState() {
    super.initState();
    setRandomValues();
    _audioPlayer.setVolume(1.0);
  }

  void setRandomValues() {
    Random random = Random();
    red1 = Robot(
      name: "OPTIMUS",
      energy: random.nextInt(7000) + 100,
      lasers: random.nextInt(50) + 1,
    );

    yellow2 = Robot(
      name: "Galactus",
      energy: random.nextInt(7000) + 100,
      lasers: random.nextInt(50) + 1,
    );
  }

  void _playSound(int type) async {
    String fileName = "";
    if (type == 1) {
      fileName = 'attack_laser.mp3';
    } else if (type == 2) {
      fileName = 'laser_shot.mp3';
    } else {
      fileName = 'explosion_yellow.mp3';
    }

    try {
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  bool _checkGaming() {
    if (red1.energy <= 0 || yellow2.energy <= 0) {
      _stopping();
      return false;
    }
    return true;
  }

  void _stopping() {
    setState(() {
      isGameOver = true;
      currentWinnerText = red1.energy <= 0 ? "Galactus won!" : "Optimus won!";
      showLotties = false;
    });
  }

  void _onFight(int type) {
    if (!_checkGaming()) return;
    _playSound(type);

    setState(() {
      if (type == 1) {
        fireRed1 = true;
        yellow2.minusEnergy(200);
        red1.minusEnergy(red1.lasers);
        Future.delayed(const Duration(seconds: 1), () => setState(() => fireRed1 = false));
      } else if (type == 2) {
        fireRed2 = true;
        yellow2.minusEnergy(200);
        red1.minusEnergy(red1.lasers);
        Future.delayed(const Duration(seconds: 1), () => setState(() => fireRed2 = false));
      } else if (type == 3) {
        fireYellow1 = true;
        red1.minusEnergy(200);
        yellow2.minusEnergy(yellow2.lasers);
        Future.delayed(const Duration(milliseconds: 1600), () => setState(() => fireYellow1 = false));
      } else if (type == 4) {
        fireYellow2 = true;
        red1.minusEnergy(200);
        yellow2.minusEnergy(yellow2.lasers);
        Future.delayed(const Duration(milliseconds: 1600), () => setState(() => fireYellow2 = false));
      }
    });
    _checkGaming();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cosmos_compositing16.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // layout (Lottie Robots)
            if (showLotties) ...[
              Positioned(
                left: -38,
                top: -50,
                child: Lottie.asset('assets/lottie/red_robot.json', width: 340, height: 340),
              ),
              if (lotty2Visible)
                Positioned(
                  left: 198,
                  top: 82,
                  child: Lottie.asset('assets/lottie/y_robot.json', width: 178, height: 180),
                ),
              if (lotty2dVisible)
                Positioned(
                  right: -38,
                  top: 130,
                  child: Lottie.asset('assets/lottie/y_robot.json', width: 178, height: 180),
                )
            ],

            // robot img (Static)
            if (showStaticImages)
              Positioned(
                top: 42,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Image.asset('assets/images/red_robot100.png', fit: BoxFit.contain, height: 220)),
                    Expanded(child: Image.asset('assets/images/img_yellow_robot100.png', fit: BoxFit.contain, height: 220)),
                  ],
                ),
              ),

            // effects
            if (fireRed1)
              Positioned(left: 40, top: 90, child: Image.asset('assets/images/fire_laser_up_to_right.png', width: 220)),
            if (fireRed2)
              Positioned(left: 40, top: 154, child: Image.asset('assets/images/image_explosion_red.jpg', width: 220)),
            if (fireYellow1)
              Positioned(right: 108, top: 90, child: Image.asset('assets/images/image_explosion_yellow.jpg', width: 120, height: 100)),
            if (fireYellow2)
              Positioned(right: 40, top: 154, child: Image.asset('assets/images/image_explosion_yellow.jpg', width: 120, height: 100)),

            // names
            Positioned(
              top: 280,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text("Optimus", textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xfff38440), fontSize: 35, fontWeight: FontWeight.bold)),
                  ),
                  Flexible(
                    child: Text("Galactus", textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xfff38440), fontSize: 35, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),

            // winner text
            Positioned(
              top: 340,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  isGameOver ? currentWinnerText : winner,
                  style: const TextStyle(color: Color(0xffecf4b4), fontSize: 38, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // energy states (Energy 1 & 2)
            Positioned(
              top: 426,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Energy: ${red1.energy}", style: TextStyle(color: Color(0xFFFFC107), fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Energy: ${yellow2.energy}", style: TextStyle(color: Color(0xFFFFC107), fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // laser states (Laser 1 & 2)
            Positioned(
              top: 468,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lasers: ${red1.lasers}", style: TextStyle(color: Color(0xFFFFC107), fontSize: 18)),
                  Text("Lasers: ${yellow2.lasers}", style: TextStyle(color: Color(0xFFFFC107), fontSize: 18)),
                ],
              ),
            ),

            // start btn
            if (!isGameStarted)
              Positioned(
                top: 500,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff650216), minimumSize: const Size(110, 60)),
                    onPressed: () => setState(() {
                      isGameStarted = true;
                      showStaticImages = false;
                      showLotties = true;
                      lotty2Visible = true;
                    }),
                    child: const Text("Start", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),

            // game controls
            if (isGameStarted && !isGameOver) ...[
              Positioned(
                top: 525,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size(110, 60)),
                      onPressed: () => _onFight(1),
                      child: const Text("Fight Up!", style: TextStyle(color: Colors.white)),
                    ),
                    if (lotty2Visible)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size(110, 60)),
                        onPressed: () => _onFight(3),
                        child: const Text("Fight Up!", style: TextStyle(color: Colors.white)),
                      )
                    else
                      const SizedBox(width: 110),
                  ],
                ),
              ),
              Positioned(
                top: 605,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size(110, 60)),
                      onPressed: () => _onFight(2),
                      child: const Text("Fight Down!", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size(110, 60)),
                      onPressed: () => _onFight(4),
                      child: const Text("Fight Down!", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),

              // hide a robot btn
              Positioned(
                bottom: 80,
                right: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffc0aef3)),
                  onPressed: () {
                    if (!_checkGaming()) return;
                    setState(() {
                      lotty2Visible = false;
                      lotty2dVisible = true;
                    });
                    Future.delayed(const Duration(seconds: 3), () => setState(() => lotty2dVisible = false));
                    Future.delayed(const Duration(seconds: 4), () => setState(() => lotty2Visible = true));
                  },
                  child: const Text("Hide \nRight Robot", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],

            // game over btn
            if (isGameOver)
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(240, 90)),
                    onPressed: () => setState(() {
                      setRandomValues();
                      isGameOver = false; // Сброс состояния игры
                      isGameStarted = true;
                      showLotties = true;
                    }),
                    child: const Text("Game Over \nStart Again", style: TextStyle(fontSize: 22, color: Colors.black)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}