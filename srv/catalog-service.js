const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Books } = this.entities;

  // Validação antes de criar ou atualizar um livro
  this.before(['CREATE', 'UPDATE'], 'Books', async (req) => {
    const { stock, price } = req.data;

    // Validar stock não negativo
    if (stock < 0) {
      req.error(400, 'O stock não pode ser negativo', 'stock');
    }

    // Validar preço positivo
    if (price && price <= 0) {
      req.error(400, 'O preço deve ser maior que zero', 'price');
    }
  });

  // Lógica após ler livros - adicionar campo calculado
  this.after('READ', 'Books', (books) => {
    if (Array.isArray(books)) {
      books.forEach(book => enrichBook(book));
    } else if (books) {
      enrichBook(books);
    }
  });

  // Função para enriquecer dados do livro
  function enrichBook(book) {
    if (book.stock < 10) {
      book.stockStatus = 'Baixo';
    } else if (book.stock < 50) {
      book.stockStatus = 'Médio';
    } else {
      book.stockStatus = 'Alto';
    }

    // Aplicar desconto se stock alto
    if (book.price && book.stock > 100) {
      book.discountedPrice = (book.price * 0.9).toFixed(2);
    }
  }

  // Log quando um livro é criado
  this.on('CREATE', 'Books', async (req, next) => {
    console.log('>>> Criando novo livro:', req.data.title);
    const result = await next();
    console.log('>>> Livro criado com ID:', result.ID);
    return result;
  });
});
