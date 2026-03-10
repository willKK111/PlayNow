import 'package:flutter/material.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/associado.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';

class CadastroNovoUsuarioAdmin extends StatefulWidget {
  const CadastroNovoUsuarioAdmin({super.key});

  @override
  _CadastroNovoUsuarioAdminState createState() => _CadastroNovoUsuarioAdminState();
}

class _CadastroNovoUsuarioAdminState extends State<CadastroNovoUsuarioAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();

  bool _isAdmin = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _repetirSenhaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _repetirSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('As senhas não coincidem'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      String? mensagem;

      final administrador = Administrador.vazio();
      if (_isAdmin) {
        administrador.nome = _nomeController.text;
        administrador.email = _emailController.text;
        administrador.telefone = _telefoneController.text;
        administrador.senha = _senhaController.text;

        mensagem = await administrador.cadastrarAdministrador(administrador);
      } else {
        final associado = Associado.vazio();
        associado.nome = _nomeController.text;
        associado.email = _emailController.text;
        associado.telefone = _telefoneController.text;
        associado.senha = _senhaController.text;

        mensagem = await administrador.cadastrarAssociado(associado);
      }

      if (!mounted) return;

      final isErro = mensagem != null && mensagem.toLowerCase().contains('erro');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem ?? 'Erro inesperado'),
          backgroundColor: isErro ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 3),
        ),
      );

      if (!isErro) {
        _formKey.currentState!.reset();
        setState(() {
          _isAdmin = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: colorScheme.onSurface),
        validator: (value) => value == null || value.isEmpty ? 'Preencha o campo $label' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.primary),
          hintText: label.toLowerCase(),
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text('PlayNow', style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Cadastro de Novo Usuário',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(icon: Icons.person, label: 'Nome', controller: _nomeController),
                  _buildTextField(icon: Icons.email, label: 'Email', controller: _emailController),
                  _buildTextField(icon: Icons.phone, label: 'Telefone', controller: _telefoneController),
                  _buildTextField(icon: Icons.lock, label: 'Senha', controller: _senhaController, obscure: true),
                  _buildTextField(icon: Icons.lock, label: 'Repetir Senha', controller: _repetirSenhaController, obscure: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('É admin?', style: TextStyle(color: colorScheme.onSurface)),
                      Checkbox(
                        value: _isAdmin,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            _isAdmin = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cadastrar',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }
}
