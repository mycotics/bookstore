class Book < ApplicationRecord
  has_one :product, as: :product_details, dependent: :destroy
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres

  validates :isbn, presence: true
end
