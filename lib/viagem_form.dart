import 'dart:convert';
import 'ViagemList.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViagemForm extends StatefulWidget {
  @override
  _ViagemFormState createState() => _ViagemFormState();
}

class _ViagemFormState extends State<ViagemForm> {
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _dataPartidaController = TextEditingController();
  final TextEditingController _dataRetornoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _buscarCidadeUF(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _cidadeController.text = data['localidade'];
        _ufController.text = data['uf'];
      });
    } else {
      // Caso ocorra algum erro na requisição, trate conforme necessário
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  void _salvarViagem() async {
    print("Método _salvarViagem chamado");
    if (_destinoController.text.isEmpty ||
        _cepController.text.isEmpty ||
        _cidadeController.text.isEmpty ||
        _ufController.text.isEmpty ||
        _dataPartidaController.text.isEmpty ||
        _dataRetornoController.text.isEmpty ||
        _statusController.text.isEmpty) {
      // Exibir mensagem de erro se algum campo estiver vazio
      _exibirMensagemErro('Por favor, preencha todos os campos.');
      return;
    }

    Map<String, dynamic> viagem = {
      'destino': _destinoController.text,
      'cep': _cepController.text,
      'cidade': _cidadeController.text,
      'uf': _ufController.text,
      'data_partida': _dataPartidaController.text,
      'data_retorno': _dataRetornoController.text,
      'status_conclusao': _statusController.text,
    };

    try {
      await _dbHelper.insertViagem(viagem);

      // Limpar os controladores após salvar
      _limparCampos();

      // Exibir mensagem de sucesso
      _exibirMensagemSucesso('Viagem cadastrada com sucesso!');
    } catch (e) {
      // Lidar com erros durante a inserção no banco de dados
      print('Erro ao salvar viagem: $e');
      _exibirMensagemErro(
          'Ocorreu um erro ao salvar a viagem. Tente novamente.');
    }
  }

  void _exibirMensagemSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exibirMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _limparCampos() {
    _destinoController.clear();
    _cepController.clear();
    _cidadeController.clear();
    _ufController.clear();
    _dataPartidaController.clear();
    _dataRetornoController.clear();
    _statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Viagem'),
        actions: [
          IconButton(
            icon: Icon(Icons.list), // Ícone de lista
            onPressed: () {
              // Navegar para a tela de listagem de viagens
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViagemList()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _destinoController,
              decoration: InputDecoration(labelText: 'Destino'),
            ),
            TextField(
              controller: _cepController,
              decoration: InputDecoration(labelText: 'CEP'),
              onChanged: (cep) {
                if (cep.length == 8) {
                  _buscarCidadeUF(cep);
                }
              },
            ),
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(labelText: 'Cidade'),
            ),
            TextField(
              controller: _ufController,
              decoration: InputDecoration(labelText: 'UF'),
            ),
            TextField(
              controller: _dataPartidaController,
              decoration: InputDecoration(labelText: 'Data de Partida'),
            ),
            TextField(
              controller: _dataRetornoController,
              decoration: InputDecoration(labelText: 'Data de Retorno'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status de Conclusão'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvarViagem,
              child: const Text('Salvar Viagem'),
            ),
          ],
        ),
      ),
    );
  }
}
