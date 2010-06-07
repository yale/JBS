class Product < ActiveRecord::Base
  
  def self.find_products_for_sale
    find(:all, :order => "title")
  end
  
  validates_presence_of :title, :image_url, :description
  validates_numericality_of :price
  validates_uniqueness_of :title
  validates_format_of :image_url,
                      :with => /\.(gif|jpg|png)$/,
                      :message => "must be either a .gif, .jpg " +
                                  "or png image"
  validate :price_must_be_at_least_a_cent
  
protected
  
  def price_must_be_at_least_a_cent
    errors.add(:price, 'should be at least $0.01') if price.nil? or price < 0.01
  end
  
  
end
