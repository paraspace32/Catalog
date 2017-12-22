class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories

  validates_presence_of :name
  validates_presence_of :price

  class << self
    def filter(params)
      return unless params.present?
      products = []
      products << includes(:categories).where(categories: { id: params.map(&:to_i) })
      products << includes(:categories).where(categories: { parent_id: params.map(&:to_i) })
      return products.flatten!
    end
  end
end
