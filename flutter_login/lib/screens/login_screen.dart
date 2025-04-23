import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Tela de Login do aplicativo
///
/// Esta tela permite que o usuário faça login com email e senha
/// ou navegue para a tela de registro caso não tenha uma conta
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();
  
  // Variável para controlar a visibilidade da senha
  bool _obscurePassword = true;
  
  // Variável para controlar o estado de carregamento
  bool _isLoading = false;
  
  // Método para fazer login
  Future<void> _signIn() async {
    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Ativa o indicador de carregamento
      });
      
      try {
        // Obtém o serviço de autenticação
        final authService = Provider.of<AuthService>(context, listen: false);
        
        // Tenta fazer login com email e senha
        await authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // Se o login for bem-sucedido, navega para a tela inicial
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        // Trata erros específicos do Firebase Auth
        String errorMessage;
        
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuário não encontrado. Verifique seu email.';
            break;
          case 'wrong-password':
            errorMessage = 'Senha incorreta. Tente novamente.';
            break;
          case 'invalid-email':
            errorMessage = 'Email inválido. Verifique o formato.';
            break;
          case 'user-disabled':
            errorMessage = 'Este usuário foi desativado.';
            break;
          default:
            errorMessage = 'Erro ao fazer login: ${e.message}';
        }
        
        // Exibe o erro em um SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        // Trata outros erros não específicos
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao fazer login: $e')),
          );
        }
      } finally {
        // Desativa o indicador de carregamento
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ou ícone do aplicativo
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                
                // Campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    // Validação básica de formato de email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Campo de senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                
                // Link para recuperação de senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navega para a tela de recuperação de senha
                      Navigator.pushNamed(context, '/reset-password');
                    },
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botão de login
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'ENTRAR',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Link para a tela de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: () {
                        // Navega para a tela de registro
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Registre-se'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    // Libera os controladores quando a tela for descartada
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
