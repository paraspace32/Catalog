module ApplicationHelper
  def sgd(price)
    number_to_currency(price, :unit => 'S$')
  end

  def filter_category
    @categories = Category.joins(:products).where(parent_id: nil)
  end
end