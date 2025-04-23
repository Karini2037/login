import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Tela de Recuperação de Senha
///
/// Esta tela permite que o usuário solicite a redefinição de senha
/// através do email cadastrado
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Controlador para o campo de email
  final TextEditingController _emailController = TextEditingController();
  
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();
  
  // Variável para controlar o estado de carregamento
  bool _isLoading = false;
  
  // Método para enviar o email de recuperação de senha
  Future<void> _resetPassword() async {
    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Ativa o indicador de carregamento
      });
      
      try {
        // Obtém o serviço de autenticação
        final authService = Provider.of<AuthService>(context, listen: false);
        
        // Envia o email de recuperação de senha
        await authService.resetPassword(_emailController.text.trim());
        
        // Exibe mensagem de sucesso
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email de recuperação enviado. Verifique sua caixa de entrada.'),
              backgroundColor: Colors.green,
            ),
          );
          // Volta para a tela de login após alguns segundos
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        // Trata erros específicos do Firebase Auth
        String errorMessage;
        
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Não há usuário registrado com este email.';
            break;
          case 'invalid-email':
            errorMessage = 'Email inválido. Verifique o formato.';
            break;
          default:
            errorMessage = 'Erro ao enviar email de recuperação: ${e.message}';
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
            SnackBar(content: Text('Erro ao enviar email de recuperação: $e')),
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
        title: const Text('Recuperar Senha'),
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
                // Ícone ou ilustração
                const Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                
                // Texto explicativo
                const Text(
                  'Insira seu email para receber um link de recuperação de senha',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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
                const SizedBox(height: 24),
                
                // Botão de enviar
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'ENVIAR',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Link para voltar à tela de login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Voltar para o login'),
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
    // Libera o controlador quando a tela for descartada
    _emailController.dispose();
    super.dispose();
  }
}
