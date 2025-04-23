import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'services/auth_service.dart';

/// Ponto de entrada principal do aplicativo
///
/// Inicializa o Firebase e configura o Provider para gerenciamento de estado
void main() async {
  // Garante que os widgets do Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializa o Firebase com as configurações padrão
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Inicia o aplicativo
    runApp(const MyApp());
  } catch (e) {
    // Em caso de erro na inicialização do Firebase, exibe uma mensagem de erro
    print('Erro ao inicializar o Firebase: $e');
    
    // Inicia o aplicativo com uma tela de erro
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Erro ao inicializar o Firebase: $e'),
          ),
        ),
      ),
    );
  }
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura o Provider para fornecer o serviço de autenticação para toda a árvore de widgets
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Firebase Login App',
        theme: ThemeData(
          // Configura o tema do aplicativo
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // Usa o AuthWrapper como rota inicial para verificar o estado de autenticação
        home: const AuthWrapper(),
        // Define as rotas do aplicativo
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
