class Size < ApplicationRecord
  has_many :product_sizes, class_name: Product::Size.name, inverse_of: :size
end
