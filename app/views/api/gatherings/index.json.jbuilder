json.partial! "api/pagination", collection: @gatherings

json.data do
  json.array! @gatherings do |gathering|
    json.partial! gathering
  end
end
