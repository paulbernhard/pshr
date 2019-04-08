require_dependency "pshr/application_controller"

module Pshr
  class UploadsController < ApplicationController
    respond_to :json

    def create
      @upload = resource.new(resource_params)
      if @upload.save
        # flash success
        # render nothing with :created status
      else
        # flash error
        # render upload form partial with :unprocessable_entity status
      end
    end

    def update
      @upload = resource.find(params[:id])
      if @upload.update_attributes(resource_params)
        # flash success
        # render upload form partial with :ok status
      else
        # flash error
        # render upload form partial with :unprocessable_entity status
      end
    end

    def destroy
      @upload = resource.find(params[:id])
      if @upload.destroy
        # flash success
        # render nothing with status :ok
      end
    end

    private

      def resource
        resource_name = params[:resource]
        resource_name.capitalize.constantize
      end

      def resource_params(resource)
        params.require(resource.name.to_sym).permit(:uploadable_type, :uploadable_id, :file, metadata: {})
      end
  end
end
