require 'test_helper'

class CustomUploadTest < ActiveSupport::TestCase

  setup do
    @upload = CustomUpload.new
  end

  test 'is invalid with blacklisted file' do
    @upload.file = File.open(file_fixture('image.gif'))
    assert_not @upload.valid?
  end

  test 'is invalid with custom max file size' do
    @upload.file = File.open(file_fixture('tires.jpg'))
    assert_not @upload.valid?
  end

  test 'uses custom processor' do
    @upload.file = File.open(file_fixture('image.jpg'))
    @upload.save
    assert_equal "image/png", @upload.mime_type
  end

  test 'accesses metadata fields' do
    caption = "hi there"
    @upload.caption = caption
    assert_equal caption, @upload.caption
    assert_equal caption, @upload.metadata['caption']
  end
end
