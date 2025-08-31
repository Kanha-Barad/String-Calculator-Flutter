import 'package:flutter/material.dart';
import 'string_calculator.dart';
import 'widgets/result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final StringCalculator _calculator = StringCalculator();
  final List<_HistoryItem> _history = [];
  String? _result;
  String? _error;
  bool _isAnimating = false;

  // delimiter settings
  String _customHeader = ''; // e.g. //;\n or //[***]\n (user enters delimiter body only like ; or [***])
  bool _useCustomDelimiter = false;

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _calculate() {
    final input = _controller.text.trim();
    setState(() {
      _result = null;
      _error = null;
    });

    String toEvaluate = input;
    if (_useCustomDelimiter && _customHeader.isNotEmpty) {
      // If user provided bracketed or plain delimiter, build header correctly
      final header = _customHeader.startsWith('[') ? _customHeader : _customHeader;
      toEvaluate = '//${header}\n$input';
    }

    try {
      final sum = _calculator.add(toEvaluate);
      setState(() {
        _result = sum.toString();
        _history.insert(0, _HistoryItem(input: input, result: sum.toString(), createdAt: DateTime.now()));
        _isAnimating = true;
      });
      _animController.forward(from: 0).then((_) {
        setState(() => _isAnimating = false);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      _showErrorDialog(e.toString());
    }
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _result = null;
      _error = null;
    });
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _openDelimiterEditor() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final TextEditingController hdr = TextEditingController(text: _customHeader);
        bool localUse = _useCustomDelimiter;
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(builder: (context, setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    const Text('Use custom delimiter:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Switch(value: localUse, onChanged: (v) => setStateModal(() => localUse = v)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: hdr,
                  decoration: const InputDecoration(
                    labelText: 'Delimiter header (e.g. ;  or [***])',
                    hintText: 'Enter ; or [***] (do not add // or \\n)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _useCustomDelimiter = localUse;
                          _customHeader = hdr.text.trim();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )
              ]),
            );
          }),
        );
      },
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter numbers (comma, newline allowed):', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'e.g. 1,2,3 or 1\\n2,3 or 1;2 (with custom delimiter)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.clear),
                  onPressed: _clear,
                ),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _openDelimiterEditor,
                icon: const Icon(Icons.settings),
                label: const Text('Delimiter'),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildResultArea() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_result != null)
            ResultCard(
              result: _result!,
              input: _controller.text.trim(),
              animate: _isAnimating,
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Text('History', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _history.clear()),
                child: const Text('Clear'),
              )
            ],
          ),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No calculations yet.'),
            ),
          for (final item in _history)
            ListTile(
              dense: true,
              title: Text(item.input),
              subtitle: Text('= ${item.result} • ${_formatTime(item.createdAt)}'),
              trailing: IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  setState(() {
                    _controller.text = item.input;
                    _calculate();
                  });
                },
              ),
            )
        ]),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('String Calculator'),
        actions: [
          IconButton(
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'String Calculator',
              applicationVersion: '1.0.0',
              children: const [Text('Built with TDD principles — demo UI')],
            ),
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width > 900) {
          // Desktop / wide layout
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildInputCard(),
                      const SizedBox(height: 16),
                      _buildResultArea(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: _buildHistory(),
                )
              ],
            ),
          );
        }

        // Mobile layout
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _buildInputCard(),
            const SizedBox(height: 12),
            _buildResultArea(),
            const SizedBox(height: 12),
            _buildHistory(),
          ]),
        );
      }),
    );
  }
}

class _HistoryItem {
  final String input;
  final String result;
  final DateTime createdAt;
  _HistoryItem({required this.input, required this.result, required this.createdAt});
}
