require 'rails/railtie'
require 'action_view/base'

module BestInPlace
  class Railtie < ::Rails::Railtie #:nodoc:
    config.after_initialize do
      if ActionView::Base.method(:new).arity == 3
        # Rails 6+ requires: lookup_context, assigns, controller
        lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
        assigns = {}
        controller = ActionController::Base.new
        BestInPlace::ViewHelpers = ActionView::Base.new(lookup_context, assigns, controller)
      else
        # Older Rails versions
        BestInPlace::ViewHelpers = ActionView::Base.new
      end
    end
  end
end
