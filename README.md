# Gerapass 

O Gerapass é um aplicativo gerenciador de senhas construído em Flutter. Ele permite que os usuários gerem senhas fortes e personalizadas, salvem-nas com segurança em um cofre na nuvem vinculado à sua conta e as acessem de qualquer lugar.
<img width="553" height="920" alt="image" src="https://github.com/user-attachments/assets/13a1943e-5840-4ca2-9211-26cbccca0beb" /> <img width="545" height="915" alt="image" src="https://github.com/user-attachments/assets/870f14c7-5070-4452-a217-c41e4e6989d3" />


## ✨ Funcionalidades Principais

### 1. Gerador de Senhas
[cite_start]O aplicativo possui uma tela dedicada para a criação de novas senhas[cite: 126], onde o usuário pode:
* [cite_start]**Definir um Rótulo:** Identificar a senha (ex: "Email Pessoal")[cite: 139].
* [cite_start]**Ajustar o Comprimento:** Escolher o tamanho da senha (de 8 a 32 caracteres) usando um slider[cite: 147].
* [cite_start]**Personalizar Caracteres:** Incluir ou excluir letras maiúsculas [cite: 148][cite_start], números [cite: 149] [cite_start]e símbolos[cite: 128, 150].
* [cite_start]**Gerar e Copiar:** Gerar a senha [cite: 129, 151] [cite_start]e copiá-la facilmente para a área de transferência[cite: 144, 145].

### 2. Cofre de Senhas (Vault)
[cite_start]As senhas geradas podem ser salvas [cite: 152] [cite_start]no Cloud Firestore[cite: 135]. [cite_start]A tela principal (`home_screen.dart`) exibe todas as senhas salvas pelo usuário[cite: 46]:
* [cite_start]**Listagem Segura:** As senhas são exibidas em uma lista, com a senha real oculta por padrão ('••••••••')[cite: 52].
* [cite_start]**Visualização:** O usuário pode tocar em um ícone para revelar ou ocultar a senha[cite: 53].
* [cite_start]**Copiar e Excluir:** É possível copiar a senha salva [cite: 54] [cite_start]ou excluí-la permanentemente (com um diálogo de confirmação)[cite: 58, 59, 60].
* [cite_start]**Estado Vazio:** Se nenhuma senha for encontrada, uma animação Lottie é exibida com uma mensagem amigável[cite: 47, 48].

### 3. Autenticação e Segurança
O acesso ao cofre é protegido por autenticação de usuário:
* [cite_start]**Firebase Auth:** O projeto utiliza Firebase Authentication para registro [cite: 120] [cite_start]e login [cite: 115] com email e senha.
* [cite_start]**Rotas Protegidas:** Um `AuthGuard` [cite: 2] [cite_start]verifica se o usuário está logado[cite: 3]. [cite_start]Se não estiver, ele é redirecionado para a tela de login [cite: 4][cite_start], protegendo o `DashboardScreen`[cite: 20].

### 4. Onboarding e Personalização
O aplicativo oferece uma experiência de usuário polida e personalizável:
* [cite_start]**Fluxo de Introdução:** Uma tela de introdução (`intro_screen.dart`) com várias páginas [cite: 66, 67] [cite_start]e animações Lottie [cite: 76] é mostrada na primeira vez que o usuário abre o app.
* [cite_start]**Não Mostrar Novamente:** O usuário pode optar por não ver a introdução novamente [cite: 82, 84][cite_start], e essa preferência é salva localmente [cite: 70] [cite_start]usando `shared_preferences`[cite: 5].
* [cite_start]**Configurações de Aparência:** A tela de configurações (`settings_screen.dart`) [cite: 154] permite ao usuário:
    * [cite_start]Alterar o modo do tema (Claro, Escuro ou Padrão do Sistema)[cite: 158, 159, 160].
    * [cite_start]Escolher uma cor primária diferente para o tema[cite: 161, 163, 164].
    * [cite_start]Ajustar o tamanho do texto do aplicativo para melhor acessibilidade[cite: 168].

## 🛠️ Tecnologias Utilizadas

* **Flutter:** Framework principal para a construção da UI.
* **Firebase:**
    * [cite_start]**Firebase Authentication:** Para login e registro de usuários[cite: 115, 120].
    * [cite_start]**Cloud Firestore:** Para armazenar as senhas salvas na nuvem, vinculadas ao UID do usuário[cite: 44, 135].
* **State Management:**
    * [cite_start]**Provider (`ChangeNotifierProvider`):** Usado para gerenciar o estado do tema (cor, modo, tamanho do texto)[cite: 10, 182].
* **Armazenamento Local:**
    * [cite_start]**shared_preferences:** Para salvar as preferências de tema [cite: 185, 186, 187] [cite_start]e a decisão de pular a introdução[cite: 5, 7].
* **Pacotes Adicionais:**
    * [cite_start]**lottie:** Para exibir animações vetoriais fluidas (ex: na tela de splash [cite: 179][cite_start], introdução [cite: 76] [cite_start]e cofre vazio [cite: 47]).
    * [cite_start]**firebase_core:** Para inicializar o Firebase no app[cite: 9].

## 📂 Estrutura do Projeto (Visão Geral)

* `main.dart`: Ponto de entrada do aplicativo. [cite_start]Inicializa o Firebase [cite: 9] [cite_start]e o `ThemeProvider`[cite: 10].
* [cite_start]`routes.dart`: Gerencia a navegação e as rotas nomeadas do app[cite: 16, 18].
* [cite_start]`core/auth_guard.dart`: Widget que protege rotas, redirecionando usuários não autenticados para o login[cite: 1, 4].
* [cite_start]`data/settings_repository.dart`: Classe responsável por salvar e ler a preferência `show_intro` no `shared_preferences`[cite: 5, 6, 7].
* [cite_start]`providers/theme_provider.dart`: Gerenciador de estado (usando `ChangeNotifier`) para as configurações de aparência [cite: 182][cite_start], persistindo-as no `shared_preferences`[cite: 188].
* `screens/`:
    * [cite_start]`splash_screen.dart`: Tela de carregamento inicial que decide para onde navegar (Intro ou Home)[cite: 170, 172].
    * [cite_start]`intro_screen.dart`: Telas de boas-vindas exibidas no primeiro uso[cite: 62].
    * [cite_start]`login_screen.dart`: Tela de login e registro com Firebase Auth[cite: 93].
    * [cite_start]`dashboard_screen.dart`: Tela principal que contém a navegação inferior (BottomAppBar) [cite: 32] [cite_start]e o `PageView` para `HomeScreen` e `SettingsScreen`[cite: 27].
    * [cite_start]`home_screen.dart`: O "cofre" que lista, exibe e gerencia as senhas salvas do Firestore[cite: 37, 46].
    * [cite_start]`NewPasswordScreen.dart`: Tela para gerar e salvar novas senhas[cite: 126].
    * [cite_start]`settings_screen.dart`: Tela onde o usuário pode personalizar o tema do aplicativo[cite: 154].
