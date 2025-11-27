# 📚 Bookshop - Projeto CAP

Aplicação de catálogo de livros desenvolvida com **SAP Cloud Application Programming Model (CAP)** no SAP Business Application Studio.

## �� Visão Geral

Este projeto demonstra uma aplicação completa de gestão de livraria com:
- Modelo de dados CDS com entidades Books, Authors e Genres
- Serviço OData v4 com validações de negócio
- Interface web para visualização de dados
- Anotações UI para melhor apresentação
- Lógica de negócio personalizada com cálculos automáticos

## 📦 Estrutura do Projeto

```
cap_dev/
├── db/                    # Modelos de dados
│   ├── schema.cds          # Definição das entidades
│   └── data/               # Dados CSV de exemplo
├── srv/                   # Camada de serviços
│   ├── catalog-service.cds      # Definição do serviço
│   ├── catalog-service.js       # Lógica de negócio
│   └── catalog-annotations.cds  # Anotações UI
├── app/                   # Aplicação web
│   └── index.html          # Página inicial
├── package.json           # Dependências
└── README.md              # Este ficheiro
```

## 📊 Modelo de Dados

### Books (Livros)
- ID, título, descrição
- Referência para Autor e Género
- Stock, preço e moeda
- Campos de auditoria (createdAt, modifiedAt)

### Authors (Autores)
- ID e nome
- Relação com múltiplos livros

### Genres (Géneros)
- ID e nome
- Estrutura hierárquica (parent/children)

## ⚙️ Funcionalidades

### Validações Automáticas
- ❌ Stock não pode ser negativo
- ❌ Preço deve ser maior que zero
- ✅ Mensagens de erro personalizadas

### Cálculos Dinâmicos
- **Status do Stock**: Baixo/Médio/Alto baseado na quantidade
- **Preço com Desconto**: 10% de desconto para stock > 100 unidades
- **Logs**: Registo de criação de novos livros

### Anotações UI
- Configuração de apresentação de listas
- Definição de cabeçalhos e títulos em português
- Organização de campos em formulários
- Campos de seleção para filtros

## 🚀 Como Executar

### Pré-requisitos
- Node.js instalado
- SAP Business Application Studio ou @sap/cds-dk instalado

### Instalação

```bash
# Instalar dependências
npm install

# Iniciar o servidor de desenvolvimento
cds watch
```

### Acesso

Após iniciar o servidor, aceda:

- **Aplicação Web**: http://localhost:4004
- **Catalog Service**: http://localhost:4004/odata/v4/catalog
- **Books**: http://localhost:4004/odata/v4/catalog/Books
- **Authors**: http://localhost:4004/odata/v4/catalog/Authors
- **Genres**: http://localhost:4004/odata/v4/catalog/Genres
- **Metadata**: http://localhost:4004/odata/v4/catalog/$metadata

## 💻 Tecnologias Utilizadas

- **SAP CAP** - Framework de desenvolvimento
- **CDS** - Core Data Services para modelagem
- **OData v4** - Protocolo REST para API
- **Node.js** - Runtime JavaScript
- **SQLite** - Base de dados em memória (desenvolvimento)

## 📝 Exemplos de Dados

### Livros
1. **Wuthering Heights** - Emily Brontë (Stock: 12, Preço: 11.11 EUR)
2. **Jane Eyre** - Charlotte Brontë (Stock: 11, Preço: 12.34 GBP)
3. **The Raven** - Edgar Allen Poe (Stock: 333, Preço: 13.13 USD)

## 🔗 Links Úteis

- [Documentação SAP CAP](https://cap.cloud.sap)
- [Exemplos CAP](https://github.com/capire/samples)
- [CDS Language Reference](https://cap.cloud.sap/docs/cds/)

## 👤 Autor

Ricardo Montanha  
GitHub: [@ricardomontanh](https://github.com/ricardomontanh)

## 📅 Histórico

- **27/11/2025** - Criação inicial do projeto
- **27/11/2025** - Adição de modelo de dados e serviços
- **27/11/2025** - Implementação de lógica de negócio
- **27/11/2025** - Adição de interface web e anotações UI

## 📢 Licença

Este projeto foi criado para fins educacionais.
