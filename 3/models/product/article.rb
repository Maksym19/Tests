class Product
  class Article < ApplicationRecord
    self.table_name = 'product_articles'

    belongs_to :product

    has_many :product_sizes, class_name: Product::Size.name,
                             foreign_key: :product_article_id,
                             inverse_of: :article
    has_many :photos, class_name: Product::Photo.name,
                      foreign_key: :product_article_id,
                      inverse_of: :article
  end
end
