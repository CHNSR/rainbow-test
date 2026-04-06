// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/config/export.dart';

// class TextScreen extends StatefulWidget {
//   final FlutterPrinter01 plugin;

//   const TextScreen({
//     super.key,
//     required this.plugin,
//   });

//   @override
//   State<TextScreen> createState() => _TextScreenState();
// }

// class _TextScreenState extends State<TextScreen> {
//   final _textController = TextEditingController(text: 'Hello, POS Printer!');
//   final _feedPaperController = TextEditingController(text: '3');
//   bool _isLoading = false;
//   String _status = '';
//   bool _success = false;

//   // Size mode
//   bool _useCustomSize = false;
//   PrinterTextSize _selectedSize = PrinterTextSize.size1;
//   int _customWidth = 1;
//   int _customHeight = 1;

//   // Style
//   PrinterAlignment _alignment = PrinterAlignment.left;
//   bool _bold = false;
//   bool _upsideDown = false;
//   bool _feedPaper = false;

//   Future<void> _printText() async {
//     setState(() => _isLoading = true);
//     try {
//       // 1. Alignment
//       await widget.plugin.text.setAlignment(_alignment);
//       // 2. Bold
//       await widget.plugin.text.setBold(_bold);
//       // 3. Upside-Down
//       await widget.plugin.text.setUpsideDown(_upsideDown);
//       // 3. Size + Print + Auto Reset
//       await widget.plugin.text.feedPaper(int.parse(_feedPaperController.text));
//       bool ok;
//       if (_useCustomSize) {
//         await widget.plugin.text.setCustomTextSize(
//           widthMultiplier: _customWidth,
//           heightMultiplier: _customHeight,
//         );
//         ok = await widget.plugin.text.printText(_textController.text);
//         await widget.plugin.text.resetTextSize();
//       } else {
//         ok = await widget.plugin.text.printTextWithSize(
//           _textController.text,
//           _selectedSize,
//         );
//       }
//       // 4. Reset style
//       await widget.plugin.text.setBold(false);
//       await widget.plugin.text.setUpsideDown(false);
//       await widget.plugin.text.setAlignment(PrinterAlignment.left);
//       await widget.plugin.text.feedPaper(int.parse(_feedPaperController.text));
//       setState(() {
//         _success = ok;
//         _status = ok ? '✅ พิมพ์สำเร็จ' : '❌ พิมพ์ไม่สำเร็จ';
//       });
//     } catch (e) {
//       setState(() {
//         _success = false;
//         _status = 'Error: $e';
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _feedPaperController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Text Printing',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         surfaceTintColor: Colors.transparent,
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.only(bottom: 40),
//         children: [
//           // ── Text Size ───────────────────────────────────────────────────
//           _buildSection(
//             title: "Text Size",
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         _ModeButton(
//                           label: 'แบบด่วน',
//                           icon: Icons.speed_outlined,
//                           selected: !_useCustomSize,
//                           onTap: () => setState(() => _useCustomSize = false),
//                         ),
//                         const SizedBox(width: 8),
//                         _ModeButton(
//                           label: 'ปรับเอง (W/H)',
//                           icon: Icons.tune_outlined,
//                           selected: _useCustomSize,
//                           onTap: () => setState(() => _useCustomSize = true),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 250),
//                       child: _useCustomSize
//                           ? _CustomSizePanel(
//                               key: const ValueKey('custom'),
//                               widthMultiplier: _customWidth,
//                               heightMultiplier: _customHeight,
//                               onWidthChanged: (v) =>
//                                   setState(() => _customWidth = v),
//                               onHeightChanged: (v) =>
//                                   setState(() => _customHeight = v),
//                             )
//                           : _QuickSizePanel(
//                               key: const ValueKey('quick'),
//                               selected: _selectedSize,
//                               onSelected: (s) =>
//                                   setState(() => _selectedSize = s),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // ── Alignment ─────────────────────────────────────────────────
//           _buildSection(
//             title: "Layout & Alignment",
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text("การจัดวางข้อความ",
//                         style: TextStyle(fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 12),
//                     SegmentedButton<PrinterAlignment>(
//                       segments: const [
//                         ButtonSegment(
//                           value: PrinterAlignment.left,
//                           icon: Icon(Icons.format_align_left),
//                           label: Text('Left'),
//                         ),
//                         ButtonSegment(
//                           value: PrinterAlignment.center,
//                           icon: Icon(Icons.format_align_center),
//                           label: Text('Center'),
//                         ),
//                         ButtonSegment(
//                           value: PrinterAlignment.right,
//                           icon: Icon(Icons.format_align_right),
//                           label: Text('Right'),
//                         ),
//                       ],
//                       selected: {_alignment},
//                       onSelectionChanged: (s) =>
//                           setState(() => _alignment = s.first),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text("เลื่อนกระดาษ (บรรทัด)",
//                         style: TextStyle(fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: _feedPaperController,
//                       enabled: !_isLoading,
//                       maxLines: 1,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'จำนวนบรรทัด...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         filled: true,
//                         fillColor: cs.surfaceContainerLow,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // ── Style ─────────────────────────────────────────────────────
//           _buildSection(
//             title: "Style",
//             children: [
//               SwitchListTile.adaptive(
//                 value: _bold,
//                 onChanged: (v) => setState(() => _bold = v),
//                 title: const Text(
//                   'ตัวหนา (Bold)',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ),
//               Divider(
//                 height: 1,
//                 indent: 16,
//                 endIndent: 16,
//                 color: Colors.grey.shade200,
//               ),
//               SwitchListTile.adaptive(
//                 value: _upsideDown,
//                 onChanged: (v) => setState(() => _upsideDown = v),
//                 title: Row(
//                   children: [
//                     const Text(
//                       'พิมพ์กลับหัว (Upside-Down)',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(width: 8),
//                     AnimatedRotation(
//                       turns: _upsideDown ? 0.5 : 0,
//                       duration: const Duration(milliseconds: 300),
//                       child: const Text('🔤', style: TextStyle(fontSize: 18)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // ── Print Button ─────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ActionButton(
//                     label: 'Test Print',
//                     icon: Icons.print_outlined,
//                     outlined: true,
//                     onTap: _printText,
//                     loading: _isLoading,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ActionButton(
//                     label: 'Save Template',
//                     icon: Icons.save,
//                     onTap: () {
//                       final templateData = {
//                         'useCustomSize': _useCustomSize,
//                         'selectedSize': _selectedSize.name,
//                         'customWidth': _customWidth,
//                         'customHeight': _customHeight,
//                         'alignment': _alignment.name,
//                         'bold': _bold,
//                         'upsideDown': _upsideDown,
//                         'feedPaper':
//                             int.tryParse(_feedPaperController.text) ?? 3,
//                       };
//                       log('📤 Sending Text Template: $templateData');
//                       Navigator.pop(context, templateData);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           if (_status.isNotEmpty) ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: StatusCard(isConnected: _success, status: _status),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   /// Section Wrapper (เหมือนหน้า SettingPage)
//   Widget _buildSection(
//       {required String title, required List<Widget> children}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//           child: Text(
//             title.toUpperCase(),
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade600,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.02),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//             border: Border.all(color: Colors.grey.shade100),
//           ),
//           child: Column(
//             children: children,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────── Sub Widgets ────────────────────────────

// class _ModeButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;
//   const _ModeButton({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: selected ? cs.primary : cs.outlineVariant,
//               width: selected ? 1.5 : 1,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 18,
//                 color: selected ? cs.primary : cs.onSurfaceVariant,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: selected ? cs.primary : cs.onSurfaceVariant,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _QuickSizePanel extends StatelessWidget {
//   final PrinterTextSize selected;
//   final ValueChanged<PrinterTextSize> onSelected;
//   const _QuickSizePanel({
//     super.key,
//     required this.selected,
//     required this.onSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: PrinterTextSize.values.map((size) {
//         final isSelected = selected == size;
//         return ChoiceChip(
//           label: Text(
//             '${size.multiplier}×',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 12.0 + (size.multiplier * 2),
//             ),
//           ),
//           selected: isSelected,
//           onSelected: (_) => onSelected(size),
//           selectedColor: Theme.of(context).colorScheme.primaryContainer,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         );
//       }).toList(),
//     );
//   }
// }

// class _CustomSizePanel extends StatelessWidget {
//   final int widthMultiplier;
//   final int heightMultiplier;
//   final ValueChanged<int> onWidthChanged;
//   final ValueChanged<int> onHeightChanged;
//   const _CustomSizePanel({
//     super.key,
//     required this.widthMultiplier,
//     required this.heightMultiplier,
//     required this.onWidthChanged,
//     required this.onHeightChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _SliderRow(
//           label: 'Width',
//           icon: Icons.swap_horiz_outlined,
//           value: widthMultiplier,
//           onChanged: onWidthChanged,
//         ),
//         const SizedBox(height: 12),
//         _SliderRow(
//           label: 'Height',
//           icon: Icons.swap_vert_outlined,
//           value: heightMultiplier,
//           onChanged: onHeightChanged,
//         ),
//         const SizedBox(height: 12),
//         // Visual Preview
//         Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surfaceContainerLow,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: Theme.of(context).colorScheme.outlineVariant,
//               ),
//             ),
//             child: Text(
//               'Aa',
//               style: TextStyle(
//                 fontSize: 14.0 * heightMultiplier.clamp(1, 4),
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: (widthMultiplier - 1) * 4.0,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SliderRow extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final int value;
//   final ValueChanged<int> onChanged;
//   const _SliderRow({
//     required this.label,
//     required this.icon,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: cs.primary),
//         const SizedBox(width: 8),
//         SizedBox(
//           width: 54,
//           child: Text(
//             '$label ${value}×',
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//           ),
//         ),
//         Expanded(
//           child: Slider(
//             value: value.toDouble(),
//             min: 1,
//             max: 8,
//             divisions: 7,
//             label: '${value}×',
//             onChanged: (v) => onChanged(v.round()),
//           ),
//         ),
//         SizedBox(
//           width: 28,
//           child: Text(
//             '${value}×',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//               color: cs.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
