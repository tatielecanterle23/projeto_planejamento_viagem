// ignore_for_file: use_build_context_synchronously

import 'package:firebase_app/core/auth_service.dart';
import 'package:firebase_app/nova_conta_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import 'viagem_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  // classe de logica
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(
                label: Text('Senha'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final usuario = await authService.login(
                  _emailController.text,
                  _senhaController.text,
                );
                if (usuario == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Usuário ou senha inválido'),
                    backgroundColor: Colors.red,
                  ));
                  //'Usuário ou senha inválida'
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViagemForm()),
                  );
                }
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NovaConta()))
                    .then((value) {
                  //_emailController.text = value['email'];
                  //_senhaController.text = value.senha;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Conta criada com sucesso'),
                    ),
                  );
                });
              },
              child: Text('Ainda não possuo uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}
