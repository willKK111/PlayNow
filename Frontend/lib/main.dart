import 'package:flutter/material.dart';
import 'package:play_now/domain/reserva.dart';
import 'package:play_now/domain/usuario.dart';
import 'package:play_now/provider/usuario_provider.dart';
import 'package:play_now/ui/pages/admin/detalhes_quadras.dart';
import 'package:play_now/ui/pages/admin/detalhes_usuarios.dart';
import 'package:play_now/ui/pages/detalhes_reservas.dart';
import 'package:provider/provider.dart';
import 'package:play_now/domain/quadra.dart';
import 'package:play_now/theme/theme.dart';
import 'package:play_now/ui/pages/admin/editar_quadras.dart';
import 'package:play_now/ui/pages/admin/home_admin_page.dart';
import 'package:play_now/ui/pages/admin/listar_quadras.dart';
import 'package:play_now/ui/pages/admin/listar_usuarios.dart';
import 'package:play_now/ui/pages/listar_reservas.dart';
import 'package:play_now/ui/pages/login_page.dart';
import 'package:play_now/ui/pages/associado/home_associado.dart';
import 'package:play_now/provider/quadra_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuadraProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MaterialTheme? theme;
  const MyApp({Key? key, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? MaterialTheme(ThemeData.light().textTheme);

    return MaterialApp(
      title: 'PlayNow',
      debugShowCheckedModeBanner: false,
      theme: effectiveTheme.light(),
      darkTheme: effectiveTheme.dark(),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/homeAdmin': (_) => HomeAdminPage(),
        '/homeAssociado': (_) => const HomeAssociadoPage(),
        '/reservas': (context) => ListaReservas(),
        '/usuarios': (context) => ListarUsuariosPage(),
        '/quadras': (context) => ListarQuadras(),
        '/detalhes-quadra': (context) {
          final quadra = ModalRoute.of(context)!.settings.arguments as Quadra;
          return DetalhesQuadraPage(quadra: quadra);
        },
        '/editar-quadra': (context) {
          final quadra = ModalRoute.of(context)!.settings.arguments as Quadra;
          return EditarQuadraPage(quadra: quadra);
        },
        '/detalhes-usuario': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
          return DetalhesUsuarioPage(usuario: usuario);
        },
        '/detalhes-reserva': (context) {
          final reserva = ModalRoute
              .of(context)!
              .settings
              .arguments as Reserva;
          return DetalhesReservaPage(reserva: reserva);
        },
      },

    );
  }
}
