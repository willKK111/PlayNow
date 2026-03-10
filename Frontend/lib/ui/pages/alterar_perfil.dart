import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/usuario_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:play_now/ui/pages/associado/widgets/bottom_navbar_associado.dart';
import 'package:play_now/ui/widgets/input_field.dart';

class AlterarPerfil extends StatefulWidget {
  const AlterarPerfil({super.key});

  @override
  State<AlterarPerfil> createState() => _AlterarPerfilState();
}

class _AlterarPerfilState extends State<AlterarPerfil> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;
  late TextEditingController senhaController;
  late TextEditingController repetirSenhaController;

  @override
  void initState() {
    super.initState();
    final usuario = Sessao.usuarioLogado!;
    nomeController = TextEditingController(text: usuario.nome);
    emailController = TextEditingController(text: usuario.email);
    telefoneController = TextEditingController(text: usuario.telefone);
    senhaController = TextEditingController(text: usuario.senha);
    repetirSenhaController = TextEditingController(text: usuario.senha);
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    repetirSenhaController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPerfil() async {
    if (senhaController.text != repetirSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final usuario = Sessao.usuarioLogado!;
    final service = UsuarioService();

    final mensagem = await service.atualizarUsuarioParcial(
      usuario: usuario,
      nome: nomeController.text != usuario.nome ? nomeController.text : null,
      email: emailController.text != usuario.email ? emailController.text : null,
      senha: senhaController.text != usuario.senha ? senhaController.text : null,
      telefone: telefoneController.text != usuario.telefone ? telefoneController.text : null,
    );

    if (context.mounted) {
      final isError = mensagem != null && mensagem.toLowerCase().contains('erro');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem!),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );

      if (!isError) {
        Sessao.usuarioLogado = usuario;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        title: Text(
          'PlayNow',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: colorScheme.onPrimary),
            tooltip: 'Sair',
            onPressed: () {
              Sessao.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      bottomNavigationBar: usuario.isAdmin
          ? BottomNavBarAdmin()
          : BottomNavBarAssociado(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InputField(Icons.person_outline, "Nome", "nome", controller: nomeController),
                      const SizedBox(height: 10),
                      InputField(Icons.email_outlined, "Email", "email", controller: emailController),
                      const SizedBox(height: 10),
                      InputField(Icons.phone_outlined, "Telefone", "telefone", controller: telefoneController),
                      const SizedBox(height: 10),
                      InputField(Icons.lock_outline, "Senha", "senha", obscure: true, controller: senhaController),
                      const SizedBox(height: 10),
                      InputField(Icons.lock_outline, "Repetir Senha", "repetirSenha", obscure: true, controller: repetirSenhaController),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _atualizarPerfil,
                          child: Text(
                            'Atualizar',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
