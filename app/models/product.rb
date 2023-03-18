class Product < ApplicationRecord
    has_many :categories

    attribute :style_name, :string

    validates :style_name, length: { minimum: 3}, presence: true, uniqueness: true
end
