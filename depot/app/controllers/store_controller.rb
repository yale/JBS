class StoreController < ApplicationController
  def index
    now = Time.now
    @date = now.strftime("%B %d, %Y")
    @time = now.strftime("%I:%M%p")
    @products = Product.find_products_for_sale
  end

end
