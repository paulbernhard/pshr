require 'test_helper'

class PostTest < ActiveSupport::TestCase

  setup do
    @one = posts(:one)
    @two = posts(:two)
  end

  test 'has uploads' do
    @one.uploads.create(file: File.open(file_fixture('image.jpg')))
    assert_equal 1, @one.uploads.size
  end

  test 'ranks uploads within own scope' do
    2.times { @one.uploads.create(file: File.open(file_fixture('image.jpg'))) }
    @two.uploads.create(file: File.open(file_fixture('image.jpg')))

    # changes order of @one.uploads
    one_upload_first = @one.uploads.ordered.first
    one_upload_last = @one.uploads.ordered.last
    one_upload_first.update(order_position: :last)
    assert_equal @one.uploads.ordered.last, one_upload_first
    # leaves order of @two.uploads untouched
    assert_equal 0, @two.uploads.first.order
  end
end
