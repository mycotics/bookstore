class BookGenre < ApplicationRecord
  belongs_to :book
  belongs_to :genre

  validates :book_id, :genre_id, presence: true
end
