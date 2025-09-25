# /path/to/best_in_place/lib/best_in_place/railtie.rb

require 'rails/railtie'
require 'action_view/base'
require 'action_controller/base' 

module BestInPlace
  class Railtie < ::Rails::Railtie #:nodoc:
    
    # ⚠️ CRITICAL: Ensure NO code here calls ActionView::Base.new directly.
    # The line at railtie.rb:37 in your old code MUST be removed or commented out.
    
    config.after_initialize do
      # All ActionView initialization logic must be safely inside this block.
      
      # Check arity for compatibility with Rails 6+ (requires 3 args) vs older Rails (requires 0 or 1)
      if ActionView::Base.method(:new).arity == 3
        # Rails 6+ requires: lookup_context, assigns, controller
        
        # 1. LookupContext
        lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
        
        # 2. Assigns
        assigns = {}
        
        # 3. Controller
        controller = ActionController::Base.new
        
        # Initialize with the 3 required arguments
        BestInPlace::ViewHelpers = ActionView::Base.new(lookup_context, assigns, controller)
      else
        # Older Rails versions
        BestInPlace::ViewHelpers = ActionView::Base.new
      end
    end
    
    # You might have other hooks or code here, but ensure nothing calls ActionView::Base.new
  end
end