import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

/// Serviço de autenticação que gerencia todas as operações relacionadas ao Firebase Auth
///
/// Esta classe utiliza o padrão ChangeNotifier para notificar os widgets sobre mudanças
/// no estado de autenticação do usuário.
class AuthService extends ChangeNotifier {
  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Getter para obter o usuário atual
  User? get currentUser => _auth.currentUser;
  
  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Método para registrar um novo usuário com email e senha
  /// 
  /// Retorna o usuário criado em caso de sucesso ou lança uma exceção em caso de erro
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Cria um novo usuário no Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      notifyListeners(); // Notifica os ouvintes sobre a mudança
      return credential;
    } catch (e) {
      // Relança a exceção para ser tratada na UI
      rethrow;
    }
  }
  
  /// Método para fazer login com email e senha
  /// 
  /// Retorna as credenciais do usuário em caso de sucesso ou lança uma exceção em caso de erro
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Faz login no Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      notifyListeners(); // Notifica os ouvintes sobre a mudança
      return credential;
    } catch (e) {
      // Relança a exceção para ser tratada na UI
      rethrow;
    }
  }
  
  /// Método para fazer logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners(); // Notifica os ouvintes sobre a mudança
    } catch (e) {
      // Relança a exceção para ser tratada na UI
      rethrow;
    }
  }
  
  /// Método para verificar se o usuário está logado
  bool isUserLoggedIn() {
    return currentUser != null;
  }
  
  /// Método para enviar email de redefinição de senha
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Relança a exceção para ser tratada na UI
      rethrow;
    }
  }
}
