import 'package:flutter/material.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/associado.dart';
import 'package:play_now/service/autenticacao_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AutenticacaoService _authService = AutenticacaoService();

  bool _mostrarSenha = false;
  bool _loading = false;

  void _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _showErro('Informe email e senha');
      return;
    }

    setState(() => _loading = true);

    try {
      Usuario usuario = await _authService.autenticar(email, senha);

      if (!mounted) return;

      if (usuario is Administrador) {
        Navigator.pushReplacementNamed(context, '/homeAdmin');
      } else if (usuario is Associado) {
        Navigator.pushReplacementNamed(context, '/homeAssociado');
      } else {
        _showErro('Tipo de usuário não reconhecido');
      }
    } catch (e) {
      _showErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required Color iconColor,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: iconColor),
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: iconColor, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: textColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color formBackground = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color iconColor = Colors.green.shade700;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Sempre escuro
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Fundo com logo
              Container(
                height: screenHeight * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png', width: 150, height: 150),
                    const SizedBox(height: 10),
                    Text(
                      'Seja bem-vindo, ao',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'PlayNow',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Formulário com fundo dinâmico
              Positioned(
                top: screenHeight * 0.35,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: formBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: textColor,
                            fontSize: theme.textTheme.headlineSmall?.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          iconColor: iconColor,
                          textColor: textColor,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _senhaController,
                          icon: Icons.lock_outline,
                          hintText: 'Senha',
                          obscureText: !_mostrarSenha,
                          iconColor: iconColor,
                          textColor: textColor,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                              color: iconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _mostrarSenha = !_mostrarSenha;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                color: iconColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : () => _login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: iconColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                : const Text(
                              'Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
