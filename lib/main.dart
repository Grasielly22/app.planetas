import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planeta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF20CC8),
        ),
        useMaterial3: true,
      ),
      home: CadastroPlaneta(),
    );
  }
}

class CadastroPlaneta extends StatefulWidget {
  @override
  _CadastroPlanetaState createState() => _CadastroPlanetaState();
}

class _CadastroPlanetaState extends State<CadastroPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _apelidoController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> planetas = ValueNotifier([]);

  void _salvarPlaneta() {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final tamanho = double.parse(_tamanhoController.text);
      final distancia = double.parse(_distanciaController.text);
      final apelido = _apelidoController.text;
      
      planetas.value = [
        ...planetas.value,
        {'nome': nome, 'tamanho': tamanho, 'distancia': distancia, 'apelido': apelido},
      ];
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Planeta $nome cadastrado com sucesso!')),
      );
      
      _limparCampos();
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _tamanhoController.clear();
    _distanciaController.clear();
    _apelidoController.clear();
  }

  void _removerPlaneta(int index) {
    final nome = planetas.value[index]['nome'];
    planetas.value = List.from(planetas.value)..removeAt(index);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Planeta $nome removido!')),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Preencha este campo';
          if (isNumeric && double.tryParse(value) == null) return 'Digite um número válido';
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    planetas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 155, 11, 162),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Cadastro de Planeta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(_nomeController, "Nome"),
                  _buildTextField(_tamanhoController, 'Tamanho (km)', isNumeric: true),
                  _buildTextField(_distanciaController, 'Distância (km)', isNumeric: true),
                  _buildTextField(_apelidoController, "Apelido"),
                  SizedBox(height: 12),
                  ElevatedButton(onPressed: _salvarPlaneta, child: Text('Salvar')),
                ],
              ),
            ),
            Divider(height: 30, thickness: 2),
            Expanded(
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: planetas,
                builder: (context, lista, _) {
                  if (lista.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum planeta cadastrado ainda!',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final planeta = lista[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('Nome: ${planeta['nome']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tamanho: ${planeta['tamanho']} km'),
                              Text('Distância: ${planeta['distancia']} km'),
                              Text('Apelido: ${planeta['apelido']}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.pinkAccent),
                            onPressed: () => _removerPlaneta(index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}