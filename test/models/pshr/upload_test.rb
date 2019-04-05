require 'test_helper'

module Pshr
  class UploadTest < ActiveSupport::TestCase

    setup do
      @upload = Pshr::Upload.new
    end

    test 'is valid' do
      @upload.file = File.open(file_fixture('image.jpg'))
      assert @upload.valid?
    end
    
    test 'is invalid without file' do
      @upload.file = nil
      assert_not @upload.valid?
    end

    test 'updates mime-type' do
      @upload.file = File.open(file_fixture('image.jpg'))
      @upload.save
      assert_equal "image/jpeg", @upload.mime_type
    end
  end
end
