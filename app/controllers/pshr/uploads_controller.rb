require_dependency "pshr/application_controller"

module Pshr
  class UploadsController < ApplicationController
    before_action :build_resource

    # create resource
    # respond with created resource
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

    # update resource
    # respond with updated resource
    def update
      @upload = @resource.find(params[:id])
      if @upload.update(resource_params)
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

    # delete resource
    # respond with a fresh @resource
    def destroy
      @upload = @resource.find(params[:id])
      if @upload.destroy
        flash.now[:error] = "Upload was deleted."
        @upload = @resource.new(uploadable_type: @upload.uploadable_type, uploadable_id: @upload.uploadable_id)
        respond_to do |format|
          format.json { render_resource :ok }
        end
      end
    end

    private

      # build resource from params
      def build_resource
        resource_name = params[:resource]
        @resource = resource_name.constantize
      end

      # strong params for resource
      def resource_params
        params.require(@resource.to_s.underscore.to_sym).permit(:uploadable_type, :uploadable_id, :file, metadata: {})
      end

      # render resource partial with status code
      def render_resource(status)
        @resource_partial = resource_partial
        render resource_response, status: status
      end

      # json response template
      def resource_response
        'pshr/uploads/response'
      end

      # partial rendered in response
      def resource_partial
        'pshr/uploads/form'
      end
  end
end
