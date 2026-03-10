import 'package:flutter/material.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/associado.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/provider/usuario_provider.dart';
import 'package:play_now/service/usuario_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:provider/provider.dart';

class EditarUsuarioPage extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioPage({super.key, required this.usuario});

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _senhaController;
  late TextEditingController _repetirSenhaController;
  bool _isAdmin = false;

  final UsuarioService _usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    _nomeController = TextEditingController(text: u.nome);
    _emailController = TextEditingController(text: u.email);
    _telefoneController = TextEditingController(text: u.telefone);
    _senhaController = TextEditingController();
    _repetirSenhaController = TextEditingController();
    _isAdmin = u.isAdmin;
  }

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
          ),
        );
        return;
      }

      String? mensagem;

      int id;
      if (_isAdmin) {
        id = (widget.usuario as Administrador).idAdministrador;
      } else {
        id = (widget.usuario as Associado).idAssociado;
      }

      if (_isAdmin) {
        final administrador = Administrador(
          idAdministrador: id,
          nome: _nomeController.text,
          email: widget.usuario.email,
          telefone: _telefoneController.text,
          senha: _senhaController.text.isEmpty ? widget.usuario.senha : _senhaController.text,
        );
        mensagem = await _usuarioService.atualizarUsuarioParcial(
          usuario: administrador,
          nome: administrador.nome,
          telefone: administrador.telefone,
          senha: _senhaController.text.isEmpty ? null : administrador.senha,
        );
      } else {
        final associado = Associado(
          idAssociado: id,
          nome: _nomeController.text,
          email: widget.usuario.email,
          telefone: _telefoneController.text,
          senha: _senhaController.text.isEmpty ? widget.usuario.senha : _senhaController.text,
        );
        mensagem = await _usuarioService.atualizarUsuarioParcial(
          usuario: associado,
          nome: associado.nome,
          telefone: associado.telefone,
          senha: _senhaController.text.isEmpty ? null : associado.senha,
        );
      }

      if (!mounted) return;

      final isErro = mensagem != null && mensagem.toLowerCase().contains('erro');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem ?? 'Erro inesperado'),
          backgroundColor: isErro
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        ),
      );

      if (!isErro) {
        final usuarioAtualizado = _isAdmin
            ? Administrador(
          idAdministrador: id,
          nome: _nomeController.text,
          email: widget.usuario.email,
          telefone: _telefoneController.text,
          senha: _senhaController.text.isEmpty ? widget.usuario.senha : _senhaController.text,
        )
            : Associado(
          idAssociado: id,
          nome: _nomeController.text,
          email: widget.usuario.email,
          telefone: _telefoneController.text,
          senha: _senhaController.text.isEmpty ? widget.usuario.senha : _senhaController.text,
        );

        context.read<UsuarioProvider>().atualizarUsuario(usuarioAtualizado);
        Navigator.pop(context, usuarioAtualizado);
      }
    }
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled,
        validator: (value) => value == null || value.isEmpty ? 'Preencha o campo $label' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
          filled: true,
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Editar Usuário',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(icon: Icons.person, label: 'Nome', controller: _nomeController),
                _buildTextField(
                  icon: Icons.email,
                  label: 'Email',
                  controller: _emailController,
                  enabled: false,
                ),
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
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarAdmin(),
    );
  }
}
