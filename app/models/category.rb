class Category < ApplicationRecord
  belongs_to :product

  validates :price, numericality: { greater_than: 0 }, presence: true
  validates :qty, numericality: { greater_than: 0 }, presence: true
end
