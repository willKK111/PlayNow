import 'package:flutter/material.dart';
import 'package:play_now/domain/administrador.dart';
import 'package:play_now/domain/categoria.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/service/categoria_service.dart';
import 'package:play_now/provider/quadra_provider.dart';
import 'package:play_now/ui/pages/admin/widgets/bottom_navbar_admin.dart';
import 'package:provider/provider.dart';

class EditarQuadraPage extends StatefulWidget {
  final Quadra quadra;

  const EditarQuadraPage({super.key, required this.quadra});

  @override
  State<EditarQuadraPage> createState() => _EditarQuadraPageState();
}

class _EditarQuadraPageState extends State<EditarQuadraPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numeroController;
  late TextEditingController _capacidadeController;
  late TextEditingController _nomeController;
  Categoria? _selectedCategoria;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();

    final quadra = widget.quadra;

    _numeroController = TextEditingController(text: quadra.numero.toString());
    _nomeController = TextEditingController(text: quadra.nome);
    _capacidadeController = TextEditingController(text: quadra.maximoPessoas.toString());
    _selectedCategoria = quadra.categoria;
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final categorias = await CategoriaService().buscarTodas();
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final quadraAtualizada = Quadra(
          idQuadra: widget.quadra.idQuadra,
          nome: _nomeController.text, // corrigido aqui
          numero: int.parse(_numeroController.text),
          maximoPessoas: int.parse(_capacidadeController.text),
          categoria: _selectedCategoria!,
        );

        final admin = Administrador.vazio();
        final mensagem = await admin.editarQuadra(quadraAtualizada);

        if (!mounted) return;

        final isErro = mensagem != null && mensagem.toLowerCase().contains("erro");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mensagem ?? (isErro ? 'Erro ao atualizar quadra' : 'Quadra atualizada com sucesso'),
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: isErro
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        );

        if (!isErro) {
          context.read<QuadraProvider>().atualizarQuadra(quadraAtualizada);
          Navigator.pop(context, quadraAtualizada);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
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
      appBar: AppBar(
        title: Text('Editar Quadra', style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Editar Quadra',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 24),

                  // CATEGORIA
                  DropdownButtonFormField<Categoria>(
                    value: _selectedCategoria,
                    items: _categorias.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.nome),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    dropdownColor: colorScheme.surface,
                    onChanged: (val) => setState(() => _selectedCategoria = val),
                    validator: (val) => val == null ? 'Selecione uma categoria' : null,
                  ),
                  const SizedBox(height: 12),

                  // NÚMERO
                  TextFormField(
                    controller: _numeroController,
                    decoration: InputDecoration(
                      labelText: 'Número',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? 'Informe o número' : null,
                  ),
                  const SizedBox(height: 12),

                  // NOME
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Informe o nome da quadra' : null,
                  ),
                  const SizedBox(height: 12),

                  // CAPACIDADE
                  TextFormField(
                    controller: _capacidadeController,
                    decoration: InputDecoration(
                      labelText: 'Capacidade',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? 'Informe a capacidade' : null,
                  ),
                  const SizedBox(height: 24),

                  // BOTÃO
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Salvar Alterações'),
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
