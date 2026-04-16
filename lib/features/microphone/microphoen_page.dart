import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/features/microphone/widgets/shazam_wg.dart' hide AppColors;
import '../../constants/colors.dart';
import '../../constants/text.dart';

class MicrophoneScreen extends StatefulWidget {
  const MicrophoneScreen({super.key});

  @override
  State<MicrophoneScreen> createState() => _MicrophoneScreenState();
}

class _MicrophoneScreenState extends State<MicrophoneScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isListening = false;
  bool _isProcessing = false;
  double _recordingTime = 0.0;
  final List<double> _audioLevels = [];
  final int _maxBars = 20;
  double _currentAmplitude = 0.0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _recordingTimer;
  Timer? _audioSimulationTimer;
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    _initAudioLevels();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initAudioLevels() {
    for (int i = 0; i < _maxBars; i++) {
      _audioLevels.add(0.0);
    }
  }

  void _simulateAudioInput() {
    if (!_isRecording) return;

    final random = Random();
    double baseLevel = 0.1 + random.nextDouble() * 0.3;

    if (random.nextDouble() > 0.7) {
      baseLevel = 0.6 + random.nextDouble() * 0.4;
    }

    _currentAmplitude = _currentAmplitude * 0.7 + baseLevel * 0.3;

    if (_audioLevels.length >= _maxBars) {
      _audioLevels.removeAt(0);
    }
    _audioLevels.add(_currentAmplitude);

    if (mounted) setState(() {});
  }

  void _startAudioSimulation() {
    _audioSimulationTimer?.cancel();
    _audioSimulationTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (_isRecording) {
            _simulateAudioInput();
          } else {
            timer.cancel();
          }
        });
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isListening = true;
      _recordingTime = 0.0;
    });

    _pulseController.repeat(reverse: true);

    _recordingTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (mounted) {
            setState(() {
              _recordingTime += 0.1;
            });
          }
        });

    _startAudioSimulation();
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    setState(() {
      _isRecording = false;
      _buttonPressed = false;
    });

    _pulseController.stop();
    _recordingTimer?.cancel();
    _audioSimulationTimer?.cancel();

    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      for (int i = 0; i < _audioLevels.length; i++) {
        _audioLevels[i] = 0.0;
      }

      setState(() {
        _isProcessing = false;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.pop();
    }
  }

  void _onButtonPressed() {
    setState(() => _buttonPressed = true);
    _startRecording();
  }

  void _onButtonReleased() {
    if (_isRecording) {
      _stopRecording();
    } else {
      setState(() => _buttonPressed = false);
    }
  }

  void _cancelRecording() {
    if (_isRecording) _stopRecording();
  }

  String _formatTime(double seconds) {
    int totalSeconds = seconds.floor();
    int minutes = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recordingTimer?.cancel();
    _audioSimulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.r;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(responsive),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.adaptive(
                    mobile: 24,
                    tablet: 32,
                    desktop: 40,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title and Subtitle
                    Column(
                      children: [
                        // Text(
                        //   'Speak',
                        //   style: AppText.appBarSemiBold.copyWith(
                        //     fontSize: 26,
                        //     color: AppColors.black,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        // Text(
                        //   'Tap mic to start',
                        //   style: AppText.subtitleRegular.copyWith(
                        //     fontSize: 16,
                        //     color: AppColors.gray,
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    CatchSvgWidget(),

                    const SizedBox(height: 40),
                    // DemoPage(),

                    const SizedBox(height: 20),

                    // Recording time (if recording)
                    if (_isRecording) ...[
                      _buildRecordingTime(responsive),
                      const SizedBox(height: 30),
                    ],

                    // Action button
                    const Spacer(),
                    _buildActionButton(responsive),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Responsive responsive) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.go('/');

            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Speak',
                style: AppText.appBarSemiBold.copyWith(
                  fontSize: 26,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildRecordingTime(Responsive responsive) {
    return Text(
      _formatTime(_recordingTime),
      style: AppText.titleBold.copyWith(
        fontSize: 24,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildActionButton(Responsive responsive) {
    final size = responsive.wp(0.2);

    return GestureDetector(
      onTapDown: (_) => _onButtonPressed(),
      onTapUp: (_) => _onButtonReleased(),
      onTapCancel: _cancelRecording,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isRecording ? AppColors.primary : AppColors.primary,

        ),
        child: Center(
          child: Icon(
            _isRecording ? Icons.pause : Icons.mic,
            color: AppColors.white,
            size: size * 0.4,
        ),
      ),
    ));
  }
}

/// ================= SVG WIDGET (FAYDALANMOQCHI BO'LSANGIZ) =================

class CatchSvgWidget extends StatelessWidget {
  const CatchSvgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return SizedBox(
      width: r.wp(1),
      height: r.hp(0.16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 ORQA SVG
          Transform.scale(
            scale: 1.20,
            child: SvgPicture.asset(
              'assets/icons/a.svg',
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            left: r.wp(0.34),
            top: r.hp(0.085),
            child: Transform.rotate(
              angle: 0.48, // 🔥 chap tomoni pastroq (egilish)
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.transparent,
                ),
                child: const Text(
                  'catch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
