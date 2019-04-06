require 'test_helper'

class CustomUploadTest < ActiveSupport::TestCase

  setup do
    @upload = CustomUpload.new
  end

  test 'is invalid with custom whitelist' do
    @upload.file = File.open(file_fixture('image.gif'))
    assert_not @upload.valid?
  end

  test 'is invalid with custom max file size' do
    @upload.file = File.open(file_fixture('tires.jpg'))
    assert_not @upload.valid?
  end

  test 'uses custom processor' do
    image_processing = Pshr.image_processing
    Pshr.image_processing = true

    @upload.file = File.open(file_fixture('image.jpg'))
    @upload.save
    assert_equal "image/png", @upload.mime_type

    Pshr.image_processing = image_processing
  end
end
