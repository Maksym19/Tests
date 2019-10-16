class AddModels < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
    end

    create_table :product_articles do |t|
      t.string :name
      t.string :url
      t.string :sku
      t.float :price

      t.references :product, foreign_key: true
    end

    create_table :sizes do |t|
      t.string :name
    end

    create_table :product_sizes do |t|
      t.string :sku
      t.boolean :available

      t.references :product_article, foreign_key: true
      t.references :size, foreign_key: true
    end

    create_table :product_photos do |t|
      t.string :url

      t.references :product_article, foreign_key: true
    end
  end
end
