import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopupMenu 2 Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Slate
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF8FAFC),
            letterSpacing: 1.2,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22D3EE), // Neon Cyan
          secondary: Color(0xFF42A5F5), // Flutter Blue
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const ModernShowcase(),
    );
  }
}

class ModernShowcase extends StatefulWidget {
  const ModernShowcase({Key? key}) : super(key: key);

  @override
  State<ModernShowcase> createState() => _ModernShowcaseState();
}

class _ModernShowcaseState extends State<ModernShowcase> {
  final CustomPopupMenuController _glassController =
      CustomPopupMenuController();
  final GlobalKey _contextualKey = GlobalKey();
  final GlobalKey<ContextualMenuState> _contextualStateKey =
      GlobalKey<ContextualMenuState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/logo.png'),
        ),
        title: const Text('<DevDashboard />'),
        actions: [
          _buildGlassMenu(),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Background decorative elements (Neon glows)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF42A5F5).withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF22D3EE).withValues(alpha: 0.1),
              ),
            ),
          ),
          // Global blur for the glowing orbs
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox(),
            ),
          ),

          // Background Code Snippet for Dev Vibes
          Positioned(
            top: 150,
            left: 30,
            child: Transform.rotate(
              angle: -0.05,
              child: Text(
                '''
CustomPopupMenu(
  barrierColor: Colors.transparent,
  pressType: PressType.singleClick,
  menuBuilder: () => Glassmorphism(),
);
                ''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white.withValues(alpha: 0.05),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Text(
                    'Tap the neon button below',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildContextualMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassMenu() {
    return CustomPopupMenu(
      controller: _glassController,
      pressType: PressType.singleClick,
      arrowColor: const Color(0xFF1E293B), // Matches the glass base color
      barrierColor: Colors.black.withValues(alpha: 0.4),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGlassMenuItem(
                    Icons.code_rounded, 'View Source', const Color(0xFF22D3EE)),
                Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                _buildGlassMenuItem(Icons.bug_report_rounded, 'Debug Mode',
                    const Color(0xFF42A5F5)),
                Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                _buildGlassMenuItem(Icons.rocket_launch_rounded, 'Deploy',
                    const Color(0xFFE879F9)),
              ],
            ),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: const Icon(Icons.more_vert_rounded, color: Color(0xFFF8FAFC)),
      ),
    );
  }

  Widget _buildGlassMenuItem(IconData icon, String title, Color neonColor) {
    return InkWell(
      onTap: () => _glassController.hideMenu(),
      splashColor: neonColor.withValues(alpha: 0.2),
      highlightColor: neonColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: neonColor, size: 22),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualMenu() {
    return ContextualMenu(
      key: _contextualStateKey,
      targetWidgetKey: _contextualKey,
      maxColumns: 3,
      backgroundColor: const Color(0xFF1E293B),
      highlightColor: const Color(0xFF22D3EE).withValues(alpha: 0.2),
      lineColor: Colors.white.withValues(alpha: 0.05),
      dismissOnClickAway: true,
      items: [
        ContextPopupMenuItem(
          onTap: () async {},
          child: const Center(
              child: Icon(Icons.terminal_rounded, color: Color(0xFF22D3EE))),
        ),
        ContextPopupMenuItem(
          onTap: () async {},
          child: const Center(
              child: Icon(Icons.data_object_rounded, color: Color(0xFF42A5F5))),
        ),
        ContextPopupMenuItem(
          onTap: () async {},
          child: const Center(
              child: Icon(Icons.memory_rounded, color: Color(0xFFE879F9))),
        ),
      ],
      child: Container(
        key: _contextualKey,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF22D3EE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22D3EE).withValues(alpha: 0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: Colors.white, size: 26),
            SizedBox(width: 10),
            Text(
              'INITIALIZE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
