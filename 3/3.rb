file = File.open(Rails.root.join('data.json'))
json = JSON.parse(file.read)

class Callable
  def self.call(*args, &block)
    new(*args, &block).call
  end
end

module Products
  class CreateOrUpdate < Callable
    def initialize(payload = {})
      @payload = payload
      @photos_payload = payload['photos'].to_a
      @product_sizes_payload = payload['sizes'].to_a
    end

    def call
      ActiveRecord::Base.transaction do
        create_or_update_product
        create_or_update_article
      end
    end

    private

    attr_reader :payload, :photos_payload, :product_sizes_payload

    def create_or_update_product
      @product = Product
        .find_or_create_by(sku: payload['product_sku'])
        .tap { |product| product.update!(product_attributes) }
    end

    def product_attributes
      { name: payload['product_name'] }
    end

    def create_or_update_article
      @article = Product::Article
        .find_or_create_by(sku: payload['article_sku'])
        .tap { |article| article.update!(article_attributes) }
    end

    def article_attributes
      {
        name: payload['article_name'],
        price: payload['price'],
        url: payload['url'],
        product: @product,
        photos: [*found_photos, *build_photos],
        product_sizes: build_product_sizes
      }
    end

    def found_photos
      @found_photos ||= ::Product::Photo
        .where(url: photos_payload.map { |attributes| attributes['url'] })
    end

    def build_photos
      found_photos_urls = found_photos.map(&:url)

      photos_payload
        .reject { |attributes| found_photos_urls.include?(attributes['url']) }
        .map { |attributes| ::Product::Photo.new(url: attributes['url']) }
    end

    def build_product_sizes
      product_sizes_payload.map(&method(:build_product_size))
    end

    def build_product_size(attributes)
      ::Product::Size
        .find_or_initialize_by(sku: attributes['size_sku'])
        .tap { |size| assign_product_size_attributes(size, attributes) }
        .tap { |size| assign_size_to_product_size(size, attributes['name']) }
    end

    def assign_product_size_attributes(product_size, attributes)
      product_size.assign_attributes(available: attributes['available'])
    end

    def assign_size_to_product_size(product_size, name)
      product_size.size = ::Size.find_or_initialize_by(name: name)
    end
  end
end

Products::CreateOrUpdate.call(json)
