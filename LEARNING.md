cat > LEARNING.md << 'ENDOFFILE'
# 🎓 Guia de Aprendizagem - Projeto Bookshop SAP CAP

**Data**: 27 de Novembro de 2025
**Projeto**: cap_dev - Bookshop Application
**Repositório**: https://github.com/ricardomontanh/cap_dev
**Ambiente**: SAP Business Application Studio

---

## 📋 ÍNDICE

1. [Visão Geral](#visao-geral)
2. [Tecnologias Aprendidas](#tecnologias)
3. [Passo a Passo (9 Passos)](#passos)
4. [Todos os Códigos Criados](#codigos)
5. [Comandos Utilizados](#comandos)
6. [Lições Aprendidas](#licoes)
7. [Próximos Passos](#proximos)

---

## 🎯 VISÃO GERAL {#visao-geral}

### O Que Foi Criado
Aplicação completa de gestão de livraria com SAP CAP incluindo:
- ✅ Modelo de dados (3 entidades)
- ✅ Serviço OData v4
- ✅ Lógica de negócio com validações
- ✅ Interface web
- ✅ Anotações UI
- ✅ Documentação
- ✅ Git/GitHub

### Duração: 3-4 horas

---

## 💻 TECNOLOGIAS APRENDIDAS {#tecnologias}

1. **SAP CAP** - Framework de desenvolvimento
2. **CDS** - Modelagem de dados
3. **OData v4** - APIs REST
4. **Node.js** - Backend JavaScript
5. **Git/GitHub** - Versionamento
6. **SAP BAS** - IDE cloud

---

## 📝 PASSO A PASSO {#passos}

### Passo 1: Modelo de Dados (30 min)

**Ficheiro**: \`db/schema.cds\`

**Código completo**:
\`\`\`cds
using { Currency, managed, cuid } from '@sap/cds/common';

namespace bookshop;

entity Books : managed {
  key ID : Integer;
  title : localized String(111);
  descr : localized String(1111);
  author : Association to Authors;
  genre : Association to Genres;
  stock : Integer;
  price : Decimal(9,2);
  currency : Currency;
}

entity Authors : managed {
  key ID : Integer;
  name : String(111);
  books : Association to many Books on books.author = \$self;
}

entity Genres {
  key ID : Integer;
  name : String(111);
  parent : Association to Genres;
  children : Composition of many Genres on children.parent = \$self;
}
\`\`\`

**Aprendizado**:
- Entidades representam objetos de negócio
- \`managed\` adiciona campos de auditoria automáticos
- Associações criam relacionamentos entre entidades
- \`localized\` permite tradução de campos

---

### Passo 2: Serviço OData (20 min)

**Ficheiro**: \`srv/catalog-service.cds\`

**Código completo**:
\`\`\`cds
using { bookshop } from '../db/schema';

service CatalogService {
  @readonly entity Books as projection on bookshop.Books;
  @readonly entity Authors as projection on bookshop.Authors;
  @readonly entity Genres as projection on bookshop.Genres;
}

using from './catalog-annotations';
\`\`\`

**Aprendizado**:
- Serviços expõem entidades via OData
- \`@readonly\` impede modificações
- Projeções selecionam dados a expor

---

### Passo 3: Dados de Exemplo (15 min)

**Ficheiro 1**: \`db/data/bookshop-Authors.csv\`
\`\`\`csv
ID;name
1;Emily Brontë
2;Charlotte Brontë
3;Edgar Allen Poe
\`\`\`

**Ficheiro 2**: \`db/data/bookshop-Books.csv\`
\`\`\`csv
ID;title;author_ID;stock;price;currency_code
1;Wuthering Heights;1;12;11.11;EUR
2;Jane Eyre;2;11;12.34;GBP
3;The Raven;3;333;13.13;USD
\`\`\`

**Aprendizado**:
- CSV facilita teste de dados
- Formato: \`namespace-Entity.csv\`
- IDs relacionam entidades

---

### Passo 4: Git e GitHub (30 min)

**Comandos executados**:
\`\`\`bash
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/ricardomontanh/cap_dev.git
git push -u origin main
\`\`\`

**Aprendizado**:
- Git versiona código
- GitHub serve como backup e portfólio
- Commits devem ser descritivos

---

### Passo 5: Lógica de Negócio (40 min)

**Ficheiro**: \`srv/catalog-service.js\`

**Código completo**:
\`\`\`javascript
const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Books } = this.entities;

  // Validação antes de criar/atualizar
  this.before(['CREATE', 'UPDATE'], 'Books', async (req) => {
    const { stock, price } = req.data;

    if (stock < 0) {
      req.error(400, 'O stock não pode ser negativo', 'stock');
    }

    if (price && price <= 0) {
      req.error(400, 'O preço deve ser maior que zero', 'price');
    }
  });

  // Enriquecer dados após leitura
  this.after('READ', 'Books', (books) => {
    if (Array.isArray(books)) {
      books.forEach(book => enrichBook(book));
    } else if (books) {
      enrichBook(books);
    }
  });

  function enrichBook(book) {
    // Status do stock
    if (book.stock < 10) {
      book.stockStatus = 'Baixo';
    } else if (book.stock < 50) {
      book.stockStatus = 'Médio';
    } else {
      book.stockStatus = 'Alto';
    }

    // Desconto para stock alto
    if (book.price && book.stock > 100) {
      book.discountedPrice = (book.price * 0.9).toFixed(2);
    }
  }

  // Log de criação
  this.on('CREATE', 'Books', async (req, next) => {
    console.log('>>> Criando novo livro:', req.data.title);
    const result = await next();
    console.log('>>> Livro criado com ID:', result.ID);
    return result;
  });
});
\`\`\`

**Aprendizado**:
- \`before\` executa antes da operação (validações)
- \`after\` executa depois (enriquecimento)
- \`on\` substitui comportamento padrão
- \`req.error()\` rejeita operações inválidas

---

### Passo 6: Interface Web (30 min)

**Ficheiro**: \`app/index.html\`

**Código completo**:
\`\`\`html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bookshop - CAP Dev</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background: #f5f5f5; 
        }
        h1 { color: #0070f2; }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); 
        }
        .links { margin: 20px 0; }
        .link-card { 
            display: inline-block; 
            padding: 15px 25px; 
            margin: 10px; 
            background: #0070f2; 
            color: white; 
            text-decoration: none; 
            border-radius: 4px; 
            transition: background 0.3s; 
        }
        .link-card:hover { background: #005bb5; }
        .info { 
            background: #e3f2fd; 
            padding: 15px; 
            border-left: 4px solid #0070f2; 
            margin: 20px 0; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Bookshop Application</h1>
        <p>Bem-vindo à aplicação Bookshop desenvolvida com SAP CAP.</p>
        
        <div class="info">
            <strong>🎯 Funcionalidades:</strong>
            <ul>
                <li>Catálogo de Livros com Autores e Géneros</li>
                <li>Validações de Stock e Preço</li>
                <li>Cálculo Automático de Descontos</li>
                <li>API OData v4</li>
            </ul>
        </div>
        
        <h2>🔗 Acesso aos Serviços</h2>
        <div class="links">
            <a href="/odata/v4/catalog" class="link-card">📋 Catalog Service</a>
            <a href="/odata/v4/catalog/Books" class="link-card">📚 Books</a>
            <a href="/odata/v4/catalog/Authors" class="link-card">✍️ Authors</a>
            <a href="/odata/v4/catalog/Genres" class="link-card">🏷️ Genres</a>
        </div>
        
        <h2>📊 Metadata</h2>
        <div class="links">
            <a href="/odata/v4/catalog/\$metadata" class="link-card">📄 Service Metadata</a>
        </div>
    </div>
</body>
</html>
\`\`\`

---

### Passo 7: Testar (15 min)

**Comando**: \`cds watch\`

**Resultado**: Servidor em http://localhost:4004

---

### Passo 8: Anotações UI (35 min)

**Ficheiro**: \`srv/catalog-annotations.cds\`

**Código completo**: (Ver ficheiro no projeto)

---

### Passo 9: Documentação (25 min)

README.md criado com toda documentação do projeto.

---

## 🔧 COMANDOS UTILIZADOS {#comandos}

### CAP
\`\`\`bash
cds init cap_dev
npm install
cds watch
\`\`\`

### Git
\`\`\`bash
git init
git add .
git commit -m "mensagem"
git push
\`\`\`

---

## ✅ LIÇÕES APRENDIDAS {#licoes}

1. ✅ CAP acelera desenvolvimento
2. ✅ CDS é poderoso para modelagem
3. ✅ Event handlers são flexíveis
4. ✅ Git é essencial
5. ✅ Documentação importa

---

## 🚀 PRÓXIMOS PASSOS {#proximos}

- [ ] Deploy na SAP BTP
- [ ] Conectar a SAP HANA
- [ ] Criar Fiori Elements completa
- [ ] Adicionar autenticação
- [ ] Testes unitários

---

**Projeto completo**: https://github.com/ricardomontanh/cap_dev
ENDOFFILE

