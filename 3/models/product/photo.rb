class Product
  class Photo < ApplicationRecord
    self.table_name = 'product_photos'

    belongs_to :article, class_name: Product::Article.name,
                         foreign_key: :product_article_id,
                         inverse_of: :photos
  end
end
