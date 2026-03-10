// lib/ui/widgets/expandable_button.dart
import 'package:flutter/material.dart';

class ExpandableButton extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool isLoading;
  final VoidCallback? onTapHeader;
  final Function(String)? onOptionSelected;
  final String? selectedOption;
  final bool isDisabled;

  const ExpandableButton({
    super.key,
    required this.title,
    required this.options,
    this.isLoading = false,
    this.onTapHeader,
    this.onOptionSelected,
    this.selectedOption,
    this.isDisabled = false,
  });

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool _isExpanded = false; // Estado interno do botão expansível

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Adicionado para depuração
    print('DEBUG: ExpandableButton Build - Título: "${widget.title}", Opções: ${widget.options.length}, IsExpanded: $_isExpanded, IsLoading: ${widget.isLoading}, IsDisabled: ${widget.isDisabled}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.isDisabled
                ? null
                : () {
              setState(() {
                _isExpanded = !_isExpanded;
                print('DEBUG: isExpanded para "${widget.title}" agora é: $_isExpanded');
              });
              // Chama a função de busca APENAS se o botão for expandido
              if (_isExpanded && widget.onTapHeader != null) {
                widget.onTapHeader!();
              }
            },
            child: Opacity(
              opacity: widget.isDisabled ? 0.6 : 1.0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.title,
                        style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: widget.isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                          : Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded) // Usando o estado interno
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: colorScheme.primary),
              )
                  : Column(
                children: widget.options.isEmpty
                    ? [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhuma opção disponível.',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  )
                ]
                    : widget.options.map((option) {
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: widget.selectedOption == option
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: widget.selectedOption == option
                        ? Icon(Icons.check, color: colorScheme.primary)
                        : null,
                    onTap: () {
                      if (widget.onOptionSelected != null) {
                        widget.onOptionSelected!(option);
                      }
                      setState(() {
                        _isExpanded = false; // Recolhe após a seleção
                      });
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}