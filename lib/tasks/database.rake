# frozen_string_literal: true

namespace :database do
  desc "Register an user given a name and an email"
  task :add_user, %i[name email] => %i[environment] do |_t, args|
    password = SecureRandom.hex
    user = User.new(name: args[:name], email: args[:email], password: password, password_confirmation: password)
    if user.save
      puts "User created with the following params: \n"
      puts "Name: #{user.name}"
      puts "Email: #{user.email}"
      puts "Password: #{password}"
    else
      puts "Error creating user: #{user.errors.messages}"
    end
  end

  desc "Update existing books with their google_id"
  task update_books_with_google_id: :environment do
    Book.all.each do |book|
      puts "handling #{book.title}"
      create_book_from_t_and_a = CreateBookFromTitleAndAuthor.new({title: book.title, author: book.author })
      new_book = create_book_from_t_and_a.perform
      if create_book_from_t_and_a.successful?
        Book.delete(new_book.id)
        new_book_params = new_book.attributes
        new_book_params["id"] = book.id
        unless book.update(new_book_params)
          puts "Problem when updating #{book.title}"
        end
      else
        puts "Problem when calling the API when updating #{book.title}: #{new_book.errors.messages}"
      end
    end
  end
end
