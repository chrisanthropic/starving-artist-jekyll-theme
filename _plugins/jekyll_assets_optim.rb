# file: _plugins/jekyll-assets.rb
# Thanks ixti; https://github.com/jekyll/jekyll-assets/issues/101

require "jekyll-assets"
require "image_optim"

image_optim = ImageOptim.new
processor = proc { |_, data| image_optim.optimize_image_data(data) || data }

%w(image/gif image/jpeg image/jpg image/png image/svg+xml).each do |type|
  Sprockets.register_preprocessor type, :image_optim, &processor  
end 
