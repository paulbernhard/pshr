# pshr
An engine for Ruby on Rails to provide polymorphic uploads (using [shrine](https://github.com/shrinerb/shrine)) with file processing and an uploader interface.

## Installation
Add pshr to your Gemfile…

```ruby
gem 'pshr'
```

… and bundle install.
```bash
$ bundle
```

Or install yourself as:
```bash
$ gem install pshr
```

<!-- Install the necessary migrations and migrate:
```bash
$ pshr:install:migrations
$ rails db:migrate
``` -->

## Setup

- initializer with settings…
- Pshr can be used with a model and requires the following columns:
```ruby
class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.text :file_data
      t.jsonb :metadata, default: {}
      t.integer :order
      t.boolean :processing
      t.references :uploadable, polymorphic: true

      t.timestamps
    end
  end
end
```
```bash
$ rails g model Upload file_data:text metadata:jsonb order:integer processing:boolean uploadable:references{polymorphic}
```
- hook `Pshr::Uploadable` into model:
```ruby
class Upload < ApplicationRecord
  include Pshr::Uploadable
end
```

```ruby
class Post < ApplicationRecord
  has_many :uploads, as: :uploadable, class_name: '::Pshr::Upload'
end
```

## Processing
- enable processing in initializer
- use a global custom processor or a custom processor per model
- override processing methods `process_image(file)`, etc

- Processing can be enabled in an initializer file or on a per-model basis. To apply processing you can use the [image_processing](https://github.com/janko/image_processing) helpers in a processor file. The processor file has to have a `self.process(file)` method and should output a single file or a files hash, to save multiple versions.

_NOTE: You can find example processors in app/uploaders/pshr/processors._

```ruby
# app/uploaders/processors/image.rb
require 'image_processing/vips'

module Processors::MyImage

  def self.process(file)
    pipeline = ImageProcessing::Vips
      .source(file)

    original = pipeline.call
    large = pipeline.resize_to_limit!(2560, 1920)
    medium = pipeline.resize_to_limit!(1920, 1080)
    small = pipeline.resize_to_limit!(1280, 800)

    { original: original,large: large, medium: medium, small: small }
  end
end
```

Enable the processor for its corresponding mime-types, either in an initializer file or on a per-model basis. With `{ image: 'Processors::MyImage', video: 'Processors::MyVideo', document: 'Processors::MyDocument' }` image files would be rendered by `Processors::MyImage`, video files by `Processors::MyVideo`, document files by `Processors::MyDocument` and any other files would not be processed.

```ruby
# set the processors globally in
# config/initializers/pshr.rb
Pshr.setup do |config|
config.processors = { image: 'Processors::MyImage' }

# set the processors per model in
# app/models/my_upload
class CustomUpload < ApplicationRecord
  # include Uploadable
  include Pshr::Uploadable

  # set uploading options
  # pshr_with(processors: { image: 'Processors::CustomImage' },
  #           whitelist: %W(image/jpeg, image/png),
  #           max_file_size: 1.megabyte)
  pshr_with processors: { image: 'Processors::CustomImage', video: 'Processors::CustomVideo' },
            whitelist: %W(image/jpeg image/jpg image/png video/mp4),
            max_file_size: 200.megabytes
end
```

## Usage

- Uploads can be ordered per associated record (using [RankedModel](https://github.com/mixonic/ranked-model)):
```ruby
uploads = Pshr::Upload.ordered # query ordered uploads
uploads.first.update_attributes(order_position: :last) # change position with integer, :up, :down, :first and :last
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
