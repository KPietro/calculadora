import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Bizarra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 31, 146, 27),
        ),
        useMaterial3: true,
      ),
      home: const CalculadoraHome(),
    );
  }
}

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});
  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _display = '0';
  double? _firstNumber;
  String? _operator;
  bool _waitingForSecond = false;
  bool _isScientific = false;

  void _numClick(String text) {
    setState(() {
      if (_waitingForSecond) {
        _display = text;
        _waitingForSecond = false;
      } else {
        _display = _display == '0' ? text : _display + text;
      }
    });
  }

  void _scientificOp(String op) {
    double val = double.tryParse(_display) ?? 0;
    double res = 0;
    switch (op) {
      case 'sin':
        res = math.sin(val);
        break;
      case 'cos':
        res = math.cos(val);
        break;
      case 'tan':
        res = math.tan(val);
        break;
      case '√':
        res = math.sqrt(val);
        break;
      case 'log':
        res = math.log(val);
        break;
      case 'x²':
        res = math.pow(val, 2).toDouble();
        break;
    }
    setState(() {
      _display = res.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '');
      _waitingForSecond = true;
    });
  }

  void _operationClick(String op) {
    setState(() {
      if (_firstNumber == null) {
        _firstNumber = double.parse(_display);
      } else if (!_waitingForSecond) {
        _calculate();
      }
      _operator = op;
      _waitingForSecond = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstNumber = null;
      _operator = null;
      _waitingForSecond = false;
    });
  }

  void _calculate() {
    if (_operator == null || _firstNumber == null) return;
    double secondNumber = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstNumber! + secondNumber;
        break;
      case '-':
        result = _firstNumber! - secondNumber;
        break;
      case '*':
        result = _firstNumber! * secondNumber;
        break;
      case '/':
        result = _firstNumber! / secondNumber;
        break;
    }
    setState(() {
      _display = result % 1 == 0
          ? result.toInt().toString()
          : result.toString();
      _firstNumber = result;
      _operator = null;
      _waitingForSecond = true;
    });
  }

  Widget _buildButton(
    String text,
    Color color,
    VoidCallback onPressed, {
    double fontSize = 28,
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // Adicionando uma borda dourada para dar um estilo JoJo
              side: const BorderSide(color: Color(0xFFFFEA00), width: 1),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          if (text == 'C') {
            return _buildButton(
              text,
              const Color(0xFFD50000), // Vermelho intenso
              _clear,
              textColor: Colors.white,
            );
          }
          if (text == '=') {
            return _buildButton(
              text,
              const Color(0xFFFFEA00), // Dourado JoJo
              _calculate,
              textColor:
                  Colors.black, // Texto preto para contrastar com o dourado
            );
          }
          // Cores para funções científicas
          if (['sin', 'cos', 'tan', '√', 'log', 'x²'].contains(text)) {
            return _buildButton(
              text,
              const Color(0xFF6A1B9A), // Roxo médio
              () => _scientificOp(text),
              fontSize: 18,
              textColor: const Color(0xFFFFEA00), // Letras douradas
            );
          }

          if (['+', '-', '×', '÷'].contains(text)) {
            String op = text == '×'
                ? '*'
                : text == '÷'
                ? '/'
                : text;
            return _buildButton(
              text,
              const Color(0xFFC51162), // Magenta (estilo Giorno/Bruno)
              () => _operationClick(op),
              textColor: Colors.white,
            );
          }

          // Botões numéricos
          return _buildButton(
            text,
            const Color(0xFF212121), // Preto/Cinza escuro
            () => _numClick(text),
            textColor: Colors.white,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro
      body: SafeArea(
        child: Column(
          children: [
            // Painel Superior
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomRight,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  // Roxo escuro estilo Star Platinum
                  color: const Color(0xFF311B92),
                  child: Text(
                    _display,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      // Dourado brilhante
                      color: Color(0xFFFFEA00),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      _isScientific ? Icons.calculate : Icons.science,
                      color: const Color(0xFFFFEA00),
                    ),
                    onPressed: () =>
                        setState(() => _isScientific = !_isScientific),
                  ),
                ),
                // Pequeno detalhe estético no topo
                const Positioned(
                  top: 20,
                  right: 20,
                  child: Text(
                    'ゴゴゴゴ', // Efeito sonoro clássico de JoJo
                    style: TextStyle(
                      color: Color(0x88FFEA00), // Dourado translúcido
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Teclado
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_isScientific) ...[
                      _buildRow(['sin', 'cos', 'tan']),
                      _buildRow(['√', 'log', 'x²']),
                    ],
                    _buildRow(['7', '8', '9', '÷']),
                    _buildRow(['4', '5', '6', '×']),
                    _buildRow(['1', '2', '3', '-']),
                    _buildRow(['0', 'C', '=', '+']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
