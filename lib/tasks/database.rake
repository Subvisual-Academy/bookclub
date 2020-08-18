# frozen_string_literal: true

namespace :database do
  desc "Register an user given a name and an email"
  task :add_user, %i[name email] => %i[environment] do |_t, args|
    password = SecureRandom.hex
    user = User.new(name: args[:name], email: args[:email], password: password, password_confirmation: password)
    if user.save
      puts "User created with the following params: \n"
      puts "Name: " + user.name
      puts "Email: " + user.email
      puts "Password: " + password
    else
      puts "Error creating user: " + user.errors.messages.to_s
    end
  end

end
