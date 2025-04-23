# Aplicativo Flutter de Login com Firebase

Este é um aplicativo Flutter que implementa um sistema de autenticação completo utilizando o Firebase Authentication. O aplicativo permite que os usuários se registrem, façam login, recuperem senhas e visualizem informações do perfil.

## Estrutura do Projeto

O projeto está organizado da seguinte forma:

```
lib/
├── firebase_options.dart      # Configurações do Firebase
├── main.dart                  # Ponto de entrada do aplicativo
├── screens/                   # Telas do aplicativo
│   ├── auth_wrapper.dart      # Gerenciador de estado de autenticação
│   ├── home_screen.dart       # Tela inicial após login
│   ├── login_screen.dart      # Tela de login
│   ├── register_screen.dart   # Tela de registro
│   └── reset_password_screen.dart # Tela de recuperação de senha
└── services/                  # Serviços do aplicativo
    └── auth_service.dart      # Serviço de autenticação
```

## Funcionalidades Implementadas

- **Registro de usuários**: Criação de contas com email e senha
- **Login de usuários**: Autenticação com email e senha
- **Recuperação de senha**: Envio de email para redefinição de senha
- **Perfil de usuário**: Visualização de informações do usuário logado
- **Logout**: Encerramento da sessão do usuário

## Tecnologias Utilizadas

- Flutter para o desenvolvimento da interface
- Firebase Authentication para autenticação
- Provider para gerenciamento de estado

## Como Executar o Projeto

1. Certifique-se de ter o Flutter instalado
2. Configure um projeto no Firebase Console
3. Adicione as configurações do Firebase ao projeto
4. Execute o comando `flutter pub get` para instalar as dependências
5. Execute o comando `flutter run` para iniciar o aplicativo

## Observações

Este é um projeto de demonstração e as configurações do Firebase são simuladas. Em um ambiente de produção, você precisaria configurar um projeto real no Firebase Console e adicionar os arquivos de configuração gerados pelo FlutterFire CLI.
