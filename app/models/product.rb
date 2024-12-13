class Product < ApplicationRecord
  belongs_to :product_details, polymorphic: true

  validates :slug, :title, :price, presence: true
  validates :slug, uniqueness: true
end
