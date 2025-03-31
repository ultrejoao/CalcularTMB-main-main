import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora TMB',
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> with SingleTickerProviderStateMixin {
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _tmb;
  bool _isMulher = true;
  double _buttonOpacity = 1.0;
  double _buttonScale = 1.0; 

  late AnimationController _controller;
  late Animation<double> _buttonHeightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonHeightAnimation = Tween<double>(begin: 50.0, end: 60.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _calcularTMB() {
    final double idade = double.tryParse(_idadeController.text) ?? 0.0;
    final double peso = double.tryParse(_pesoController.text) ?? 0.0;
    final double altura = double.tryParse(_alturaController.text) ?? 0.0;

    if (_isMulher) {
      _tmb = 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * idade);
    } else {
      _tmb = 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * idade);
    }

    setState(() {});
  }

  void _exibirResultado() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultado(tmb: _tmb),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora TMB'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(
                labelText: 'Idade (anos)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _alturaController,
              decoration: InputDecoration(
                labelText: 'Altura (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pesoController,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Row(
                children: [
                  Text('Feminino'),
                  Switch(
                    value: _isMulher,
                    onChanged: (value) {
                      setState(() {
                        _isMulher = value;
                      });
                    },
                  ),
                  Text('Masculino'),
                ],
              ),
            ),
            // BOTAO COM FADE EFFECT
            InkWell(
              onTap: () {
                setState(() {
                  _buttonOpacity = 0.5;
                });
                _calcularTMB();
                Future.delayed(Duration(milliseconds: 300), () {
                  setState(() {
                    _buttonOpacity = 1.0;
                  });
                });
              },
              child: AnimatedOpacity(
                opacity: _buttonOpacity,
                duration: Duration(milliseconds: 300),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _buttonScale = 1.5; // ANIMAÇÃO DE AUMENTAR O BOTAO QUANDO PASSA O CURSOR DO MOUSE - ANIMATEDSIZE
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _buttonScale = 1.0; 
                    });
                  },
                  child: Transform.scale(
                    scale: _buttonScale,
                    child: ElevatedButton(
                      onPressed: null, 
                      child: Text('Calcular TMB'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  
                  setState(() {
                    _controller.forward(); 
                  });
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          TelaResultado(tmb: _tmb),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return RotationTransition(
                          turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text('Ver Resultado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaResultado extends StatelessWidget {
  final double? tmb;

  TelaResultado({required this.tmb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Sua Taxa Metabólica Basal é: ${tmb?.toStringAsFixed(2)} kcal/dia',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
