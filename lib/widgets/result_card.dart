import 'package:flutter/material.dart';

class ResultCard extends StatefulWidget {
  final String result;
  final String input;
  final bool animate;

  const ResultCard({
    super.key,
    required this.result,
    required this.input,
    this.animate = false,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scale,
      child: Card(
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Result', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(widget.result, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  onPressed: () {
                    // copy to clipboard
                    // using ScaffoldMessenger for feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Result copied to clipboard (placeholder)')),
                    );
                  },
                  icon: const Icon(Icons.copy_all),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Input: ${widget.input}', style: const TextStyle(fontSize: 12, color: Colors.black54))
          ]),
        ),
      ),
    );
  }
}
