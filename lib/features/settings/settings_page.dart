import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tsuki/core/theme/app_colors.dart';

const _version = 'v0.1.0-alpha';
const _build = 'Dynamic';
const _license = 'MIT';
const _projectAge = '5 months';
const _flutterVer = '3.x';
const _architecture = 'Clean + BLoC';
const _language = 'Dart';
const _backend = 'AWS';
const _status = 'Active';
const _upiId = 'mridul22552007sharma@okhdfcbank';
const _githubUrl = 'https://github.com/MridulSharma2552007';
const _developerName = 'Mridul Sharma';
const _developerRole = 'Flutter Developer';

const _quotes = [
  'Stay curious.',
  'There is always another bug.',
  'Happy listening.',
  'See you on the next commit.',
  'Keep it simple.',
  'Less is more.',
  'Code is poetry.',
  'Music is the silence between the notes.',
];

final _techStack = [
  'Flutter',
  'Dart',
  'BLoC',
  'Clean Architecture',
  'AWS',
  'API Gateway',
  'Lambda',
  'Cognito',
  'Hive',
  'youtube_explode_dart',
  'just_audio',
];

final _thanks = [
  'Flutter',
  'Open Source Community',
  'yt-dlp developers',
  'youtube_explode_dart contributors',
  'just_audio',
  'AWS Free Tier',
];

final _links = <_LinkItem>[
  _LinkItem('GitHub', _githubUrl),
  _LinkItem('Report Issue', null),
  _LinkItem('Feature Request', null),
  _LinkItem('Changelog', null),
  _LinkItem('Privacy Policy', null),
];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  int _versionTapCount = 0;
  Timer? _versionTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _versionTimer?.cancel();
    super.dispose();
  }

  void _onVersionTap() {
    _versionTapCount++;
    _versionTimer?.cancel();
    _versionTimer = Timer(const Duration(seconds: 3), () {
      _versionTapCount = 0;
    });
    if (_versionTapCount >= 7) {
      _versionTapCount = 0;
      _showEasterEggTerminal();
    }
  }

  void _showEasterEggTerminal() {
    showDialog(
      context: context,
      builder: (_) => const _TerminalDialog(
        lines: [
          r'$ whoami',
          'mridul',
          r'$ pwd',
          '~/projects/tsuki',
          r'$ uptime',
          'Still coding...',
        ],
      ),
    );
  }

  void _showRandomQuote() {
    final quote = _quotes[Random().nextInt(_quotes.length)];
    showDialog(
      context: context,
      builder: (_) => _TerminalDialog(lines: [quote]),
    );
  }

  void _showDevEasterEgg() {
    showDialog(
      context: context,
      builder: (_) => const _TerminalDialog(
        lines: [r'$ sudo make coffee', 'Permission denied.'],
      ),
    );
  }

  void _showCopiedMessage() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.terminalSurface,
              border: Border.all(color: AppColors.terminalAmber),
            ),
            child: const Text(
              '> UPI ID copied to clipboard.',
              style: TextStyle(
                color: AppColors.terminalAmber,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.terminalSurface,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _showRandomQuote,
                child: const _AsciiLogo(),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _onVersionTap,
                child: Text(
                  'Version  : $_version\nBuild     : $_build\nLicense   : $_license',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    color: AppColors.terminalAmber,
                    height: 1.4,
                  ),
                ),
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ ABOUT TSUKI ]'),
              const SizedBox(height: 8),
              const _TypingBio(
                'Tsuki is an open-source terminal-inspired music player '
                'built with Flutter.\n\n'
                'The goal of the project is not to imitate Spotify or '
                'YouTube Music, but to create a calm, distraction-free '
                'listening experience inspired by old computers and '
                'retro terminals.\n\n'
                'Everything is handcrafted with simplicity and performance '
                'in mind.',
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ DEVELOPER ]'),
              const SizedBox(height: 8),
              GestureDetector(
                onLongPress: _showDevEasterEgg,
                child: const _InfoBox(
                  children: [
                    _StatRow(label: 'Name', value: _developerName),
                    _StatRow(label: 'Role', value: _developerRole),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'I started Tsuki as a passion project to learn software '
                'engineering while building something I would personally '
                'use every day.',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  color: AppColors.terminalAmber,
                  height: 1.5,
                ),
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ STACK ]'),
              const SizedBox(height: 8),
              ..._techStack.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '\u{2713} $t',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: AppColors.terminalAmber,
                    ),
                  ),
                ),
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ PROJECT STATS ]'),
              const SizedBox(height: 8),
              const _InfoBox(
                children: [
                  _StatRow(label: 'Project Age', value: _projectAge),
                  _StatRow(label: 'Flutter', value: _flutterVer),
                  _StatRow(label: 'Architecture', value: _architecture),
                  _StatRow(label: 'Language', value: _language),
                  _StatRow(label: 'Backend', value: _backend),
                  _StatRow(label: 'Status', value: _status),
                ],
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ SUPPORT ]'),
              const SizedBox(height: 8),
              const Text(
                'If Tsuki made your day a little better and you\'d like to '
                'support future development, you can buy me a coffee.',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  color: AppColors.terminalAmber,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.terminalAmber),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'QR',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _upiId,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 13,
                        color: AppColors.terminalAmber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: _upiId));
                        _showCopiedMessage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.terminalAmber),
                        ),
                        child: const Text(
                          '[COPY]',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 11,
                            color: AppColors.terminalAmber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ LINKS ]'),
              const SizedBox(height: 8),
              ..._links.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _TerminalLink(text: link.name, url: link.url),
                ),
              ),
              const _TerminalDivider(),
              const _SectionHeader('[ SPECIAL THANKS ]'),
              const SizedBox(height: 8),
              ..._thanks.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '\u{2713} $t',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: AppColors.terminalAmber,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _AsciiLogo extends StatelessWidget {
  const _AsciiLogo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        r'''
████████╗███████╗██╗   ██╗██╗  ██╗██╗
╚══██╔══╝██╔════╝██║   ██║██║ ██╔╝██║
   ██║   ███████╗██║   ██║█████╔╝ ██║
   ██║   ╚════██║██║   ██║██╔═██╗ ██║
   ██║   ███████║╚██████╔╝██║  ██╗██║
   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝
''',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 9,
          color: AppColors.terminalAmber,
          height: 1.1,
        ),
      ),
    );
  }
}

class _TerminalDivider extends StatelessWidget {
  const _TerminalDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 1,
        color: AppColors.terminalAmber.withValues(alpha: 0.3),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 16,
          color: AppColors.terminalAmber,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final List<Widget> children;
  const _InfoBox({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.terminalAmber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final dots = '.' * (18 - label.length);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: AppColors.terminalAmber,
            ),
          ),
          Text(
            dots,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: AppColors.terminalAmber.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: AppColors.terminalAmber,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkItem {
  final String name;
  final String? url;
  const _LinkItem(this.name, this.url);
}

class _TerminalLink extends StatefulWidget {
  final String text;
  final String? url;
  const _TerminalLink({required this.text, this.url});

  @override
  State<_TerminalLink> createState() => _TerminalLinkState();
}

class _TerminalLinkState extends State<_TerminalLink> {
  bool _hovered = false;

  void _onTap() {
    final url = widget.url;
    if (url == null) return;
    Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.terminalSurface,
              border: Border.all(color: AppColors.terminalAmber),
            ),
            child: Text(
              '> ${widget.text} URL copied to clipboard.',
              style: const TextStyle(
                color: AppColors.terminalAmber,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: Text(
        '> ${widget.text}',
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 13,
          color: _hovered ? AppColors.terminalSurface : AppColors.terminalAmber,
          backgroundColor: _hovered
              ? AppColors.terminalAmber
              : Colors.transparent,
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (mounted) setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visible ? '_' : ' ',
      style: const TextStyle(
        fontFamily: 'Courier',
        fontSize: 16,
        color: AppColors.terminalAmber,
      ),
    );
  }
}

class _TypingBio extends StatefulWidget {
  final String text;
  const _TypingBio(this.text);

  @override
  State<_TypingBio> createState() => _TypingBioState();
}

class _TypingBioState extends State<_TypingBio> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          widget.text,
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 12,
            color: AppColors.terminalAmber,
            height: 1.5,
          ),
          speed: const Duration(milliseconds: 20),
        ),
      ],
      totalRepeatCount: 1,
      isRepeatingAnimation: false,
      displayFullTextOnTap: true,
    );
  }
}

class _TerminalDialog extends StatelessWidget {
  final List<String> lines;
  const _TerminalDialog({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.terminalSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.terminalAmber),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 14,
                    color: AppColors.terminalAmber,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.terminalAmber),
                ),
                child: const Text(
                  '[ OK ]',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    color: AppColors.terminalAmber,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
