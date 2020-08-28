module ApplicationHelper
  def convert_user_id_to_name(user_id)
    User.find(user_id).name if user_id
  end

  def convert_book_id_to_title(book_id)
    Book.find(book_id).title if book_id
  end
end
