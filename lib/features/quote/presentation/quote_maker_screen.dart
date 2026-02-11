import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/cyber_background.dart';
import '../../../shared/widgets/cyber_card.dart';

enum _QuoteTemplate { neon, terminal, paper }

class QuoteMakerScreen extends StatefulWidget {
  const QuoteMakerScreen({super.key});

  @override
  State<QuoteMakerScreen> createState() => _QuoteMakerScreenState();
}

class _QuoteMakerScreenState extends State<QuoteMakerScreen> {
  final _controller = TextEditingController();
  final _screenshotController = ScreenshotController();
  double _fontSize = 28;
  _QuoteTemplate _template = _QuoteTemplate.neon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Quote Maker')),
      body: CyberBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 22),
            child: Column(
              children: [
                CyberCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Quote',
                          hintText: 'Write a line worth sharing...',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Template',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _QuoteTemplate.values
                            .map(
                              (template) => ChoiceChip(
                                label: Text(_templateName(template)),
                                selected: _template == template,
                                onSelected: (_) {
                                  setState(() => _template = template);
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Font size'),
                          Expanded(
                            child: Slider(
                              min: 16,
                              max: 58,
                              value: _fontSize,
                              onChanged: (value) =>
                                  setState(() => _fontSize = value),
                            ),
                          ),
                          Text(_fontSize.round().toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: Screenshot(
                      controller: _screenshotController,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _quoteCard(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _shareQuote,
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Share Quote Card'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quoteCard(BuildContext context) {
    final style = _templateStyle(_template);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: style.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: style.borderColor.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style.label,
            style: TextStyle(
              color: style.metaColor,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            _controller.text.trim().isEmpty
                ? '"Your next insight starts with one page."'
                : '"${_controller.text.trim()}"',
            style: TextStyle(
              color: style.textColor,
              fontFamily: 'cormorant',
              fontSize: _fontSize,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'copia',
              style: TextStyle(color: style.metaColor, letterSpacing: 1.1),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareQuote() async {
    final bytes = await _screenshotController.capture(pixelRatio: 2);
    if (bytes == null) {
      return;
    }
    await Share.shareXFiles([
      XFile.fromData(bytes, mimeType: 'image/png', name: 'copia_quote.png'),
    ], text: 'Made with Copia');
  }

  String _templateName(_QuoteTemplate template) {
    switch (template) {
      case _QuoteTemplate.neon:
        return 'Neon';
      case _QuoteTemplate.terminal:
        return 'Terminal';
      case _QuoteTemplate.paper:
        return 'Paper';
    }
  }

  _TemplateStyle _templateStyle(_QuoteTemplate template) {
    switch (template) {
      case _QuoteTemplate.neon:
        return const _TemplateStyle(
          label: 'NEON MODE',
          colors: [Color(0xFF071427), Color(0xFF11396F), Color(0xFF1ABEF7)],
          textColor: Colors.white,
          metaColor: Color(0xFFD2F6FF),
          borderColor: Color(0xFF80E8FF),
        );
      case _QuoteTemplate.terminal:
        return const _TemplateStyle(
          label: 'TERMINAL MODE',
          colors: [Color(0xFF041107), Color(0xFF0B2510), Color(0xFF1E4A17)],
          textColor: Color(0xFFCBFFD5),
          metaColor: Color(0xFFA5E8B0),
          borderColor: Color(0xFF7AF399),
        );
      case _QuoteTemplate.paper:
        return const _TemplateStyle(
          label: 'PAPER MODE',
          colors: [Color(0xFFFFF7E5), Color(0xFFFCEED8), Color(0xFFF6E2C3)],
          textColor: Color(0xFF493319),
          metaColor: Color(0xFF6F583E),
          borderColor: Color(0xFFDAB98D),
        );
    }
  }
}

class _TemplateStyle {
  const _TemplateStyle({
    required this.label,
    required this.colors,
    required this.textColor,
    required this.metaColor,
    required this.borderColor,
  });

  final String label;
  final List<Color> colors;
  final Color textColor;
  final Color metaColor;
  final Color borderColor;
}
