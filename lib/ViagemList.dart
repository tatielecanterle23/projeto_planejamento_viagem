import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'viagem_form.dart';

class ViagemList extends StatefulWidget {
  @override
  _ViagemListState createState() => _ViagemListState();
}

class _ViagemListState extends State<ViagemList> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _viagens = [];

  @override
  void initState() {
    super.initState();
    _carregarViagens();
  }

  Future<void> _carregarViagens() async {
    List<Map<String, dynamic>> viagens = await _dbHelper.getViagens();
    setState(() {
      _viagens = viagens;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Viagens'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViagemForm()),
              ).then((value) {
                if (value == true) {
                  _carregarViagens();
                }
              });
            },
          ),
        ],
      ),
      body: _viagens.isEmpty
          ? Center(
              child: Text('Nenhuma viagem cadastrada.'),
            )
          : ListView.builder(
              itemCount: _viagens.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> viagem = _viagens[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destino: ${viagem['destino']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('CEP: ${viagem['cep']}'),
                        Text('Cidade: ${viagem['cidade']}'),
                        Text('UF: ${viagem['uf']}'),
                        Text('Data de Partida: ${viagem['data_partida']}'),
                        Text('Data de Retorno: ${viagem['data_retorno']}'),
                        Text(
                            'Status de Conclusão: ${viagem['status_conclusao']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
