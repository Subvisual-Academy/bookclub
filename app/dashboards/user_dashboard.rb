require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    email: Field::String,
    name: Field::String,
    password: Field::Password,
    password_confirmation: Field::Password,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    moderator: Field::Boolean
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    email
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    email
    moderator
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    email
    password
    password_confirmation
    moderator
  ].freeze

  COLLECTION_FILTERS = {}.freeze
end
