class Product < ApplicationRecord
  has_one :article, class_name: Product::Article.name
end
