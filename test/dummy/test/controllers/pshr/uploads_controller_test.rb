require 'test_helper'

module Pshr
  class UploadsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @path = file_fixture('image.jpg')
    end

    test '#create is success' do
      assert_difference('Upload.count', 1) do
        post  uploads_url,
              params: { upload: { file: Rack::Test::UploadedFile.new(@path, 'image/jpeg') },
                        format: :json },
              xhr: true
      end
      assert_response :success
      assert_not JSON.parse(response.body)['flashes'].blank?
    end

    test '#create with invalid upload fails' do
      assert_no_difference('Upload.count') do
        post  uploads_url,
              params: { upload: { file: nil }, format: :json },
              xhr: true
      end
      assert_response :unprocessable_entity
      assert_not JSON.parse(response.body)['flashes'].blank?
    end

    test '#update is success' do
      @upload = Upload.create(file: File.open(@path))
      caption = "this is a caption"
      patch upload_url(@upload),
            params: { upload: { metadata: { caption: caption } }, format: :json },
            xhr: true
      assert_response :success
      assert_not JSON.parse(response.body)['flashes'].blank?
      assert_equal caption, @upload.reload.metadata['caption']
    end

    test 'destroy is success' do
      @upload = Upload.create(file: File.open(@path))
      assert_difference('Upload.count', -1) do
        delete  upload_url(@upload), params: { format: :json },
                xhr: true
      end
      assert_response :success
      assert_not JSON.parse(response.body)['flashes'].blank?
    end
  end
end
