# /path/to/best_in_place/lib/best_in_place/railtie.rb

require 'rails/railtie'
require 'action_view/base'
# This is needed to get ActionController::Base which defines view_paths
require 'action_controller/base' 

module BestInPlace
  class Railtie < ::Rails::Railtie #:nodoc:
    
    # ⚠️ IMPORTANT: Remove any direct calls to ActionView::Base.new outside this block!
    # e.g., if the original gem had: BestInPlace::ViewHelpers = ActionView::Base.new 
    # anywhere here, it MUST be removed.

    # All logic for ViewHelpers instantiation is moved into the after_initialize hook.
    config.after_initialize do
      # On Rails 6+ (and some 5.x versions), ActionView::Base.new requires 3 arguments.
      # We check the arity to be compatible with both newer and older Rails versions.
      if ActionView::Base.method(:new).arity == 3
        # Rails 6+ and newer Rails versions require: lookup_context, assigns, controller
        # We need to construct these required objects.
        
        # 1. LookupContext: Required for finding templates
        lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
        
        # 2. Assigns: A hash for instance variables, usually empty for this purpose
        assigns = {}
        
        # 3. Controller: An instance of a controller (Base is fine)
        # Note: This object must be created, not nil.
        controller = ActionController::Base.new
        
        # Initialize with the 3 required arguments
        BestInPlace::ViewHelpers = ActionView::Base.new(lookup_context, assigns, controller)
      else
        # Older Rails versions (e.g., Rails 4) require 0 or 1 arguments
        BestInPlace::ViewHelpers = ActionView::Base.new
      end
    end
  end
end