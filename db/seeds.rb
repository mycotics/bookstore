require 'json'


file_path = Rails.root.join('db', 'seeds', 'books.json')
books_data = JSON.parse(File.read(file_path))


books_data.each do |book_data|
  book = Book.create!(
    id: book_data['id'],
    book_format: book_data["book_format"],
    pages: book_data["pages"],
    publisher: book_data["publisher"],
    publish_date: book_data["publish_date"],
    isbn: book_data["isbn"],
    img_path: book_data["img_path"],
    score: book_data["score"]
  )

  Product.create!(
    id: book_data['id'],
    slug: book_data["slug"],
    title: book_data["title"],
    description: book_data["description"],
    price: book_data["price"],
    product_details: book
  )

  book_data["author"].each do |author_data|
    author = Author.find_or_create_by!(name: author_data["name"])
    BookAuthor.create!(
      book: book,
      author: author,
      author_type: author_data["type"]
    )
  end

  book_data["genres"].each do |genre_name|
    genre = Genre.find_or_create_by!(name: genre_name)
    BookGenre.create!(book: book, genre: genre)
  end

  puts "Created Book: #{book_data['id']} out of #{books_data.size} books"
end


puts "Seeding completed successfully!"