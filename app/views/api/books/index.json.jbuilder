json.partial! "api/pagination", collection: @books

json.data do
  json.array! @books do |book|
    json.partial! book
  end
end
