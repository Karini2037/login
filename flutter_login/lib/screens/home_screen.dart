import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Tela inicial do aplicativo após o login
///
/// Esta tela é exibida quando o usuário está autenticado
/// e mostra informações do usuário e opção de logout
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o serviço de autenticação
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        centerTitle: true,
        actions: [
          // Botão de logout
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Exibe diálogo de confirmação
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
              
              // Se o usuário confirmou o logout
              if (shouldLogout == true) {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navega para a tela de login
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                } catch (e) {
                  // Exibe erro caso ocorra algum problema
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao fazer logout: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar do usuário
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Informações do usuário
              Text(
                'Bem-vindo!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              
              // Email do usuário
              Text(
                user?.email ?? 'Usuário',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              
              // Card com informações adicionais
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Informações da conta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      
                      // ID do usuário
                      Row(
                        children: [
                          const Icon(Icons.fingerprint),
                          const SizedBox(width: 8),
                          const Text(
                            'ID: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              user?.uid ?? 'Não disponível',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Status de verificação de email
                      Row(
                        children: [
                          const Icon(Icons.verified_user),
                          const SizedBox(width: 8),
                          const Text(
                            'Email verificado: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user?.emailVerified == true ? 'Sim' : 'Não',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Data de criação da conta
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          const Text(
                            'Conta criada em: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user?.metadata.creationTime != null
                                ? _formatDate(user!.metadata.creationTime!)
                                : 'Não disponível',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Botão para atualizar perfil (exemplo)
              ElevatedButton.icon(
                onPressed: () {
                  // Aqui você poderia navegar para uma tela de edição de perfil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade a ser implementada'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Método para formatar a data
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
