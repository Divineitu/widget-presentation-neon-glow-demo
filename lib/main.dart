import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// This just sets the theme to dark, so the effect can be more visible
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const NeonGlowPage(),
    );
  }
}

// Using a StatefulWidget here because we need an animation that keeps running
class NeonGlowPage extends StatefulWidget {
  const NeonGlowPage({super.key});

  @override
  State<NeonGlowPage> createState() => _NeonGlowPageState();
}

class _NeonGlowPageState extends State<NeonGlowPage>
    with SingleTickerProviderStateMixin {

  // AnimationController drives the pulse, it counts from 0 to 1 repeatedly
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // reverse: true makes it go 0 to 1 to 0 to 1
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        // AnimatedBuilder rebuilds the widget every time the controller changes
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // the text
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF00FFFF), Color(0xFF0080FF)], 
                  ).createShader(bounds),
                  child: const Text(
                    'NEON GLOW',  
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,  // the text colour has to be white because ShaderMask will replace the colour with the gradient
                      letterSpacing: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // animated button
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Color.lerp(const Color(0xFF00FFFF), const Color(0xFFFF00FF), _controller.value)!,
                      Color.lerp(const Color(0xFF0080FF), const Color(0xFFFF0080), _controller.value)!,
                    ],
                  ).createShader(bounds),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Text(
                      'FLUTTER',
                      style: TextStyle(
                        color: Colors.white, // the text colour has to be white because ShaderMask will replace the colour with the gradient
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}