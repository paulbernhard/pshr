require_dependency "pshr/application_controller"

module Pshr
  class UploadsController < ApplicationController
    before_action :build_resource

    def create
      @upload = @resource.new(resource_params)
      if @upload.save
        flash.now[:success] = "Upload was successful."
        respond_to do |format|
          format.json { render_resource :created }
        end
      else
        flash.now[:error] = "Upload failed."
        respond_to do |format|
          format.json { render_resource :unprocessable_entity }
        end
      end
    end

    def update
      @upload = @resource.find(params[:id])
      if @upload.update_attributes(resource_params)
        flash.now[:success] = "Upload was updated."
        respond_to do |format|
          format.json { render_resource :ok }
        end
      else
        flash.now[:error] = "Upload update failed."
        respond_to do |format|
          format.json { render_resource :unprocessable_entity }
        end
      end
    end
    #
    def destroy
      @upload = @resource.find(params[:id])
      if @upload.destroy
        flash.now[:error] = "Upload was deleted."
        @upload = @resource.new
        respond_to do |format|
          format.json { render_resource :ok }
        end
      end
    end

    private

      def build_resource
        resource_name = params[:resource]
        @resource = resource_name.constantize
      end

      def resource_params
        params.require(@resource.to_s.downcase.to_sym).permit(:uploadable_type, :uploadable_id, :file, metadata: {})
      end

      def render_resource(status)
        @resource_partial = resource_partial
        render resource_response, status: status
      end

      def resource_response
        'pshr/uploads/form'
      end

      def resource_partial
        'pshr/uploads/form'
      end
  end
end
