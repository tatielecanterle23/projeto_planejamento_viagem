import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  Future<Map<String, dynamic>> getAddressFromCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao obter dados do CEP');
    }
  }
}
