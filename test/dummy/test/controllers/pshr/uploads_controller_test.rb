require 'test_helper'

module Pshr
  class UploadsControllerTest < ActionDispatch::IntegrationTest
    # include Engine.routes.url_helpers

    setup do
      @path = file_fixture('image.jpg')
      @upload = Upload.create(file: File.open(@path))
      @post = posts(:one)
    end

    test "index without parent is success" do
      get uploads_path, xhr: true
      assert_response :success
    end

    test "index with parent is success" do
      @post_upload = @post.uploads.build
      @post_upload.file = File.open(@path)
      @post_upload.save
      get uploads_path(uploadable_type: @post.class.to_s, uploadable_id: @post.id), xhr: true
      assert_response :success
    end

    test "show is success" do
      get upload_path(id: @upload.id, params: { format: :json }), xhr: true
      assert_response :success
    end

    test 'create is success' do
      assert_difference('Upload.count', 1) do
        post uploads_path,
          params: { upload: { file: Rack::Test::UploadedFile.new(@path, 'image/jpeg') },
            format: :json },
          xhr: true
      end
      assert_response :success
      assert_not JSON.parse(response.body)['flash'].blank?
    end

    test 'create with invalid upload fails' do
      assert_no_difference('Upload.count') do
        post uploads_path,
          params: { upload: { file: nil },
            format: :json },
          xhr: true
      end
      assert_response :unprocessable_entity
      assert_not JSON.parse(response.body)['flash'].blank?
    end

    test "edit is success" do
      get edit_upload_path(id: @upload.id, params: { format: :json }), xhr: true
      assert_response :success
    end

    test 'update is success' do
      @path = file_fixture("image.gif")
      patch upload_url(@upload),
        params: { upload: { file: Rack::Test::UploadedFile.new(@path, 'image/gif') }, format: :json },
        xhr: true
      assert_response :success
      assert_not JSON.parse(response.body)['flash'].blank?
      assert_equal "image/gif", @upload.reload.mime_type
    end

    test 'destroy is success' do
      assert_difference('Upload.count', -1) do
        delete upload_url(@upload), params: { format: :json }, xhr: true
      end
      assert_response :success
      assert_not JSON.parse(response.body)['flash'].blank?
    end

    test "sort uploads is success" do
      @upload_two = Upload.create(file: File.open(file_fixture("image.gif")))
      first = Upload.ordered.first
      last = Upload.ordered.last
      assert first.order < last.order

      post sort_upload_path(id: @upload.id, index: 1)
      assert first.reload.order > last.reload.order
    end
  end
end
