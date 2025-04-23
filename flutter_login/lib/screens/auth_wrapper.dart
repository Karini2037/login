import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Widget para verificar o estado de autenticação do usuário
///
/// Este widget observa o estado de autenticação e redireciona o usuário
/// para a tela apropriada (login ou home) com base no estado atual
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o serviço de autenticação
    final authService = Provider.of<AuthService>(context);
    
    // Observa o stream de mudanças no estado de autenticação
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Verifica se a conexão está em estado de espera
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibe um indicador de carregamento enquanto aguarda
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Verifica se há um usuário autenticado
        if (snapshot.hasData && snapshot.data != null) {
          // Se houver um usuário, redireciona para a tela inicial
          return const HomeScreen();
        } else {
          // Se não houver um usuário, redireciona para a tela de login
          return const LoginScreen();
        }
      },
    );
  }
}
