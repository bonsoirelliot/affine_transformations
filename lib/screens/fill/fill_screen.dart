import 'package:affinnes/screens/fill/filler.dart';
import 'package:affinnes/screens/fill/image_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FillScreen extends StatefulWidget {
  const FillScreen({super.key});

  @override
  State<FillScreen> createState() => _FillScreenState();
}

class _FillScreenState extends State<FillScreen> {
  int selectedAlgorytm = 0;
  Color currentColor = Colors.white;
  Color pickerColor = Colors.white;
  final filler = Filler();
  Uint8List? _initialImage;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final data = await generateImage();

    setState(() {
      _initialImage = data!.buffer.asUint8List();
      image = _initialImage;
    });
  }

  void fillEmpty() {
    setState(() {
      image = _initialImage;
    });
  }

  void fillImage() async {
    if (image != null) {
      final _image = selectedAlgorytm == 0
          ? await filler.floodFillImage(
              _initialImage!,
              10,
              90,
              currentColor,
            )
          : await filler.rowFillImage(
              _initialImage!,
              10,
              90,
              currentColor,
            );

      setState(() {
        image = _image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.memory(image!)
            else
              const SizedBox(
                height: 500,
                width: 500,
              ),
            Row(
              children: [
                _AlgorytmSelect(
                  groupValue: selectedAlgorytm,
                  onChanged: (val) {
                    setState(() {
                      selectedAlgorytm = val!;
                    });
                  },
                ),
                _ColorSelect(
                  fillColor: currentColor,
                  onColorChanged: (_) {
                    setState(() {
                      pickerColor = _;
                    });
                  },
                  onColorSelect: () {
                    setState(() {
                      currentColor = pickerColor;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                FilledButton(
                  onPressed: fillImage,
                  child: const Text(
                    'Выполнить заливку',
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                FilledButton(
                  onPressed: fillEmpty,
                  child: const Text(
                    'Убрать заливку',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlgorytmSelect extends StatelessWidget {
  const _AlgorytmSelect({
    required this.groupValue,
    this.onChanged,
    super.key,
  });

  final int groupValue;

  final void Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Выбранный алгоритм заливки:'),
        RadioMenuButton<int>(
          value: 0,
          groupValue: groupValue,
          onChanged: onChanged,
          child: const Text('С затравкой'),
        ),
        RadioMenuButton<int>(
          value: 1,
          groupValue: groupValue,
          onChanged: onChanged,
          child: const Text('Построчное сканирование'),
        ),
      ],
    );
  }
}

class _ColorSelect extends StatelessWidget {
  const _ColorSelect({
    required this.fillColor,
    required this.onColorChanged,
    required this.onColorSelect,
    super.key,
  });

  final Color fillColor;

  final void Function(Color) onColorChanged;

  final VoidCallback onColorSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Выбранный цвет:'),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: fillColor,
                      onColorChanged: onColorChanged,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Выбрать'),
                      onPressed: () {
                        onColorSelect.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: 30,
            width: 30,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
