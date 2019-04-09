class CustomUploadsController < Pshr::UploadsController

  private

    def resource_partial
      'custom_uploads/form'
    end
end
