# lib/best_in_place/railtie.rb
require 'rails/railtie'

module BestInPlace
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      ActionView::Base.include(BestInPlace::ViewHelpers)
    end
  end
end
