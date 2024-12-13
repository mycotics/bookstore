class BookAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  validates :book_id, :author_id, :author_type, presence: true
end
