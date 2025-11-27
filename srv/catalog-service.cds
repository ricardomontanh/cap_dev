using { bookshop } from '../db/schema';

service CatalogService {
  @readonly entity Books as projection on bookshop.Books;
  @readonly entity Authors as projection on bookshop.Authors;
  @readonly entity Genres as projection on bookshop.Genres;
}

using from './catalog-annotations';
