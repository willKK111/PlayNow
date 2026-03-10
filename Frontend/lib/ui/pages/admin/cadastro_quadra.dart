import 'package:flutter/material.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/categoria.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/domain/sessao.dart';
import 'package:play_now/service/categoria_service.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';

class CadastroQuadraPage extends StatefulWidget {
  @override
  _CadastroQuadraPageState createState() => _CadastroQuadraPageState();
}

class _CadastroQuadraPageState extends State<CadastroQuadraPage> {
  final _formKey = GlobalKey<FormState>();
  Categoria? _selectedCategoria;
  final _numeroController = TextEditingController();
  final _nomeController = TextEditingController();
  final _capacidadeController = TextEditingController();
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    final CategoriaService service = CategoriaService();
    try {
      final categorias = await service.buscarTodas();
      setState(() {
        _categorias = categorias ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao carregar categorias'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _nomeController.dispose();
    _capacidadeController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final int numero = int.parse(_numeroController.text);
        final int capacidade = int.parse(_capacidadeController.text);
        final String nome = _nomeController.text;
        final categoriaSelecionada = _selectedCategoria;

        if (categoriaSelecionada == null) return;

        final quadra = Quadra(
          idQuadra: 0,
          nome: nome,
          numero: numero,
          maximoPessoas: capacidade,
          categoria: categoriaSelecionada,
        );

        final Administrador administrador = Administrador.vazio();
        final mensagem = await administrador.cadastrarQuadra(quadra);

        if (!mounted) return;

        final isError = mensagem != null && mensagem.toLowerCase().contains('erro');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagem ?? 'Erro inesperado'),
            backgroundColor: isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 3),
          ),
        );

        if (!isError) {
          _numeroController.clear();
          _capacidadeController.clear();
          _nomeController.clear();
          setState(() => _selectedCategoria = null);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'PlayNow',
          style: textTheme.headlineSmall?.copyWith(color: colorScheme.onPrimary),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Container(
            height: 500,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Cadastro de Quadra',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: DropdownButtonFormField<Categoria>(
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        hintText: 'Selecione uma categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                      ),
                      items: _categorias.map((cat) {
                        return DropdownMenuItem<Categoria>(
                          value: cat,
                          child: Text(cat.nome, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                        );
                      }).toList(),
                      value: _selectedCategoria,
                      onChanged: (val) => setState(() => _selectedCategoria = val),
                      validator: (val) => val == null ? 'Selecione uma categoria' : null,
                      dropdownColor: colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        hintText: 'Número da quadra',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      validator: (val) => val == null || val.isEmpty ? 'Informe o número' : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: 'Nome da quadra',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                      ),
                      style: TextStyle(color: colorScheme.onSurface),
                      validator: (val) => val == null || val.isEmpty ? 'Informe o nome da quadra' : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: _capacidadeController,
                      decoration: InputDecoration(
                        labelText: 'Capacidade',
                        hintText: 'Capacidade de pessoas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      validator: (val) => val == null || val.isEmpty ? 'Informe a capacidade' : null,
                    ),
                  ),
                  const SizedBox(height: 46),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _submit,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Cadastrar',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
