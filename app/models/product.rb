class Product < ApplicationRecord
    has_many :categories

    validates :style_name, length: { minimum: 2}, presence: true, uniqueness: true
end
