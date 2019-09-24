require_dependency "pshr/application_controller"

module Pshr
  class UploadsController < ApplicationController
    before_action :build_resource
    before_action :set_resource, only: [:show, :edit, :update]

    def index
      if params[:uploadable_id].nil? && params[:uploadable_type].nil?
        @uploads = @resource.ordered
      else
        @uploads = @resource.where("uploadable_id = ? and uploadable_type = ?", params[:uploadable_id], params[:uploadable_type]).ordered
      end

      respond_to do |format|
        format.json { render "index", status: :ok }
      end
    end

    def show
      respond_to do |format|
        format.json { render_resource "upload", :ok }
      end
    end

    def create
      @upload = @resource.new(resource_params)
      if @upload.save
        flash.now[:success] = "Upload was successful"
        respond_to do |format|
          format.json { render_resource "upload", :created }
        end
      else
        flash.now[:error] = "Upload failed"
        respond_to do |format|
          format.json { render_resource "form", :unprocessable_entity }
        end
      end
    end

    def edit
      respond_to do |format|
        format.json { render_resource "form", :ok }
      end
    end

    def update
      if @upload.update(resource_params)
        flash.now[:success] = "Upload was updated"
        respond_to do |format|
          format.json { render_resource "upload", :ok }
        end
      else
        flash.now[:error] = "Upload update failed"
        respond_to do |format|
          format.json { render_resource "form", :unprocessable_entity }
        end
      end
    end

        def destroy
      @upload = @resource.find(params[:id])
      if @upload.destroy
        flash.now[:success] = "Upload was deleted"
        @upload = @resource.new(uploadable_type: @upload.uploadable_type, uploadable_id: @upload.uploadable_id)
        respond_to do |format|
          format.json { render_resource "form", :ok }
        end
      end
    end

    def sort
      @upload = Upload.find(params[:id])
      @upload.update order_position: params[:index]
      render body: nil, status: :ok
    end

    private

      # build resource from params[:resource] name
      def build_resource
        resource_name = params[:resource]
        @resource = resource_name.constantize
      end

      # set resource from params[:resource] name
      def set_resource
        @upload = @resource.find(params[:id])
      end

      # strong params for resource
      def resource_params
        params.require(@resource.to_s.underscore.to_sym).permit(:uploadable_type, :uploadable_id, :file, metadata: {})
      end

      # render resource partial with status code
      def render_resource(partial, status)
        @resource_partial = partial
        render "response", status: status
      end

      # partial rendered in response
      def resource_partial
        'pshr/uploads/form'
      end
  end
end
