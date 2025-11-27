using CatalogService as service from './catalog-service';

annotate service.Books with @(
  UI.LineItem : [
    {$Type: 'UI.DataField', Value: ID, Label: 'ID'},
    {$Type: 'UI.DataField', Value: title, Label: 'Título'},
    {$Type: 'UI.DataField', Value: author.name, Label: 'Autor'},
    {$Type: 'UI.DataField', Value: stock, Label: 'Stock'},
    {$Type: 'UI.DataField', Value: price, Label: 'Preço'},
    {$Type: 'UI.DataField', Value: currency_code, Label: 'Moeda'},
  ],
  UI.HeaderInfo : {
    TypeName: 'Livro',
    TypeNamePlural: 'Livros',
    Title: {Value: title},
    Description: {Value: author.name}
  },
  UI.SelectionFields : [ID, author_ID],
  UI.FieldGroup #Details : {
    Data: [
      {$Type: 'UI.DataField', Value: ID, Label: 'ID'},
      {$Type: 'UI.DataField', Value: title, Label: 'Título'},
      {$Type: 'UI.DataField', Value: descr, Label: 'Descrição'},
      {$Type: 'UI.DataField', Value: author_ID, Label: 'Autor'},
      {$Type: 'UI.DataField', Value: genre_ID, Label: 'Género'},
      {$Type: 'UI.DataField', Value: stock, Label: 'Stock'},
      {$Type: 'UI.DataField', Value: price, Label: 'Preço'},
      {$Type: 'UI.DataField', Value: currency_code, Label: 'Moeda'},
    ]
  },
  UI.Facets : [
    {
      $Type: 'UI.ReferenceFacet',
      Label: 'Detalhes do Livro',
      Target: '@UI.FieldGroup#Details'
    }
  ]
);

annotate service.Authors with @(
  UI.LineItem : [
    {$Type: 'UI.DataField', Value: ID, Label: 'ID'},
    {$Type: 'UI.DataField', Value: name, Label: 'Nome do Autor'},
  ],
  UI.HeaderInfo : {
    TypeName: 'Autor',
    TypeNamePlural: 'Autores',
    Title: {Value: name}
  }
);

annotate service.Genres with @(
  UI.LineItem : [
    {$Type: 'UI.DataField', Value: ID, Label: 'ID'},
    {$Type: 'UI.DataField', Value: name, Label: 'Nome do Género'},
  ],
  UI.HeaderInfo : {
    TypeName: 'Género',
    TypeNamePlural: 'Géneros',
    Title: {Value: name}
  }
);
