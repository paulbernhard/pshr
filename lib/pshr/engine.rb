module Pshr
  class Engine < ::Rails::Engine
    isolate_namespace Pshr

    # include methods and helpers in host app
    initializer 'pshr.include_methods_and_helpers' do

      ActiveSupport.on_load(:action_controller) do
        # include controller methods with 'include Skrw::Concerns::ApplicationController'
        # include view helpers with 'helper Pshr::UploadHelper'
        # …

        helper Pshr::UploadHelper
      end
    end
  end
end
