# ![Cinepanda](https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/logo_full.png)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0.0-blue.svg)](https://flutter.dev) [![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Pesquise e salve a lista de seus filmes favoritos, desenvolvido como teste para a empresa Senff.

## **Recursos**

- Favoritos: Acompanhe a lista dos filmes que você salvou como favoritos, sempre à mão quando quiser rever.
- Pesquisa: Busque e descubra detalhes dos filmes, incluindo em qual streaming eles estão disponíveis.
- Me Surpreenda: Sem ideia do que assistir? Clique e deixe que o app te sugira algo inesperado!

## **Instalação**

### Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) 3.0 ou superior.
- Dart SDK.
- Emulador Android ou iOS ou dispositivo físico.

### Passos de Instalação

1. Clone este repositório:

   ```bash
   git clone https://github.com/MatheusOlleNascimento/cinepanda.git
   cd cinepanda
   ```

   Instale as dependências:

   ```bash
   flutter pub get
   ```

   Configure as chaves de API no arquivo .env na raíz do projeto:
   .env

   ```bash
   API_URL='https://api.themoviedb.org/3/';
   API_KEY=seu_api_key_aqui
   ```

   Para gerar sua API_KEY siga este passo a passo:

   https://developer.themoviedb.org/reference/intro/getting-started

   Selecione o dispositivo no VS Code ou qualquer outra IDE e execute o projeto:

   ```bash
   flutter run
   ```

Estrutura do projeto:

```
|-- lib/
    |-- main.dart          # Ponto de entrada do aplicativo
    |-- src/
        |-- components/    # Componentes reutilizáveis da interface do usuário
        |-- database/      # Gerenciamento de banco de dados
        |-- imports/       # Importações em gerais para melhorar leitura do código e facilitar visualizar responsabilidades
        |-- models/        # Modelos de dados utilizados no aplicativo
        |-- providers/     # Gerenciamento de estado e lógica de negócios
        |-- services/      # Serviços de API e integração com backend
        |-- styles/        # Definições de temas e estilos visuais do aplicativo
        |-- utils/         # Funções utilitárias e auxiliares
        |-- views/         # Telas do aplicativo
```

Demonstração:

<table>
  <tr>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/splash.jpeg" width="250"/></td>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/tela_inicial.jpeg" width="250"/></td>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/favoritos.jpeg" width="250"/></td>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/me_surpreenda.jpeg" width="250"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/sem_internet.jpeg" width="250"/></td>    
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/detalhamento.jpeg" width="250"/></td>
    <td><img src="https://github.com/MatheusOlleNascimento/cinepanda/blob/main/assets/demos/sem_favoritos.jpeg" width="250"/></td>
  </tr>
</table>
