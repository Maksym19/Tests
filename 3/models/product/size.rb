class Product
  class Size < ApplicationRecord
    self.table_name = 'product_sizes'

    belongs_to :size, class_name: ::Size.name
    belongs_to :article, class_name: Product::Article.name,
                         foreign_key: :product_article_id,
                         inverse_of: :product_sizes
  end
end
