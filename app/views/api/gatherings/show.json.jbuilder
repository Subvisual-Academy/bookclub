json.partial! @gathering
json.books @gathering.books, partial: "api/books/book", as: :book
