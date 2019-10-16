class Callable
  def self.call(*args, &block)
    new(*args, &block).call
  end
end

module Products
  module Relations
    class Update < Callable
      def initialize(payload = {})
        @payload = payload
        @related_sku_list = payload['related_sku'].to_a
      end

      def call
        related_sku_list.each { |sku| find_or_create_relation(sku) }
      end

      private

      attr_reader :payload, :related_sku_list

      def find_or_create_relation(sku)
        target_article = related_articles.find { |article| article.sku == sku }

        Products::Relation
          .find_or_create_by(source: source_article, target: target_article)
      end

      def source_article
        @source_article ||= Product::Article.find_by!(
          sku: payload['article_sku']
        )
      end

      def related_articles
        @related_articles ||= Product::Article.where(sku: related_sku_list)
      end
    end
  end
end

file = File.open(Rails.root.join('data1.json'))
json = JSON.parse(file.read)

Products::Relations::Update.call(json)
