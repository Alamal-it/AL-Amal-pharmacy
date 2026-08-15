import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;

  const CountdownTimer({super.key, required this.duration});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remaining = widget.duration;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (remaining.inSeconds <= 0) {
        timer?.cancel();
        return;
      }

      setState(() {
        remaining = remaining - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffFDECEC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Colors.redAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}