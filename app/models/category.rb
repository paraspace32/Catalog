class Category < ActiveRecord::Base
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_one :parent, class_name: "Category", primary_key: :parent_id, foreign_key: :id

  has_and_belongs_to_many :products

  validates_presence_of :name
end
