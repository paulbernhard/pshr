require 'test_helper'

class CustomUploadsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @path = file_fixture('image.jpg')
  end

  test '#create with additional caption is success' do
    caption = "hi there"
    assert_difference('CustomUpload.count', 1) do
      post  custom_uploads_url,
            params: { customupload: { file: Rack::Test::UploadedFile.new(@path, 'image/jpeg'),
                      metadata: { caption: caption } },
                      format: :json },
            xhr: true
    end
    assert_response :success
    assert_equal caption, CustomUpload.last.caption
  end
end
