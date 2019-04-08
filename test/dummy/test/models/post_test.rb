require 'test_helper'

class PostTest < ActiveSupport::TestCase

  setup do
    @one = posts(:one)
    @two = posts(:two)
  end

  test 'can have uploads' do
    upload = @one.uploads.build
    upload.file = File.open(file_fixture('image.jpg'))
    upload.save
    assert_equal 1, @one.uploads.size
  end

  test 'ranks uploads within post scope' do
    2.times { @one.uploads.create(file: File.open(file_fixture('image.jpg'))) }
    @two.uploads.create(file: File.open(file_fixture('image.jpg')))

    # changes order of @one.uploads, but not of @two.uploads
    one_first_upload = @one.uploads.ordered.first
    one_last_upload = @one.uploads.ordered.last
    one_first_upload.update_attributes(order_position: :last)
    assert_equal @one.uploads.ordered.first, one_last_upload
    assert_equal 0, @two.uploads.first.order
    debugger
  end
end
