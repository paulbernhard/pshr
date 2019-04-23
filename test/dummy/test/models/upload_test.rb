require 'test_helper'

class UploadTest < ActiveSupport::TestCase

  setup do
    @upload = Upload.new
  end

  test 'is valid' do
    @upload.file = File.open(file_fixture('image.jpg'))
    assert @upload.valid?
  end

  test 'is invalid without file' do
    @upload.file = nil
    assert_not @upload.valid?
  end

  test 'is valid with txt file formats' do
    @upload.file = File.open(file_fixture('text.txt'))
    assert @upload.valid?
  end

  test 'updates mime-type' do
    @upload.file = File.open(file_fixture('image.jpg'))
    @upload.save
    assert_equal "image/jpeg", @upload.mime_type
  end

  test 'is ranked' do
    3.times do
      Upload.create(file: File.open(file_fixture('image.jpg')))
    end
    first = Upload.ordered.first
    last = Upload.ordered.last

    first.update_attributes(order_position: :down)
    assert_equal Upload.ordered.second, first

    last.update_attributes(order_position: :first)
    assert_equal Upload.ordered.first, last
  end
end
