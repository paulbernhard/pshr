# pshr
An engine for Ruby on Rails to provide polymorphic uploads (using [shrine](https://github.com/shrinerb/shrine)) with file processing and an uploader interface.

## Requirements
- Rails 5.2.2
- Webpacker

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

To use the Oshr upliader UI
```ruby
# app/assets/stylesheets/application.css
*= require pshr/styles
```
…and copy the js files (webpacker needed)

## Setup

- initializer with settings…
- Pshr initializes Shrine using the `Tus` filesystem as cache storage. This is necessary to use Pshr with the frontend file uploader. If file uploads should only be handled programatically, it might be more convenient to use the regular file system as cache. To do so, add an initialzer for Shrine with:
```ruby
# config/initialzers/shrine.rb
Shrine.storages[:cache] = Shrine::Storage::FileSystem.new(Pshr.uploads_dir, prefix: File.join(Pshr.uploads_prefix, "/cache"))
```
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
- Pshr comes with an `UploadsController` that can be used with any model you plug Pshr to. You can either use `Pshr::UploadsController` directly, inherit from it, or write your own controller. Set the routes in your app:
```ruby
# app/config/routes.rb
resources :uploads, controller: 'pshr/uploads',
                    defaults: { resource: 'Upload' },
                    only: [:create, :update, :destroy]
```
Set the `resource` in `defaults` to your upload model and set the controller to `pshr/uploads` or your own controller. You can set multiple routes for different upload resources and use your own controllers:

```ruby
# app/config/routes.rb
resources :my_uploads, controller: 'pshr/my_uploads',
                    defaults: { resource: 'MyUpload' },
                    only: [:create, :update, :destroy]

# app/controllers/my_uploads_controller.rb
class MyUploadsController < Pshr::UploadsController
  before_action :authenticate_user!
end
```

Pshr comes with an upload form partial. You can use your own form partial be overriding `app/views/pshr/uploads/_form.html.erb` in your app. Or you can specify a partial per controller by overriding the `resource_partial` method and provide your own strong parameters:

```erb
# app/views/uploads/_my_form.html.erb
<%= form_with model: upload, url: main_app.url_for(upload) do |form| %>
  <%= form.hidden_field :uploadable_type, value: form.object.uploadable_type %>
  <%= form.hidden_field :uploadable_id, value: form.object.uploadable_id %>

  <%= form.file_field :file %>

  <%= form.text_field :caption %>

  <%= form.submit "Upload" %>
<% end %>
```

_NOTE: To add additional form fields to an upload (such as a caption), just override the `pshr/uploads/_additional_fields.html.erb` partial. The partial receives a `form` object and can be used like:_

```erb
# app/views/pshr/uploads/_additional_fields.html.erb
<%= form.label :caption, "Caption" %>
<%= form.text_field :caption %>
```

_NOTE: The response expects the local variable `upload` to build the form tag. If you add your own form fields (e.g. `form.text_field :caption`), do not forget to update the controllers strong parameters._

```ruby
# app/controllers/my_uploads_controller.rb
class MyUploadsController < Pshr::UploadsController

  private

    def resource_partial
      'uploads/my_form'
    end

    def resource_params
      params.require(@resource.to_s.downcase.to_sym).permit(:uploadable_type, :uploadable_id, :file, :caption)
    end
end
```

## Processing / Versions
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

- Versions: Each upload can have multiple versions which can be created during the processing. To save versions instead of one file, return a versions hash from the processing method. See example at `app/uploaders/processors/image.rb` or shrine's [versions plugin doc](https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/versions.md#readme) for more info.

_NOTE: The upload model will keep track of the uploaded file mime-type in the `metadata` column. If you provide versions, the first version file will be used as mime-type. E.g. processing a file to create multiple versions with different formats should return a hash with the file to identify the upload's mime-type first, e.g. `{ mp4: 'video.mp4', mov: 'video.mov', still: 'still.mp4' }`._

## Uploads Interface
- requires: webpacker, stimulus
```bash
$ yarn add @uppy/core @uppy/tus @uppy/drag-drop @uppy/informer
```
- copy js folders (as engines do not yet support webpacker)
- add `javascript_pack_tag 'pshr_application.js'` to `application.html.erb`
- the upload panel has an uploader to add uploads to a collection of uploads (optionally within a scope of parent)…

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :uploads, as: :uploadable, dependent: :destroy
end
```

… in your view you can implement the upload panel like:

```html
<%= pshr_upload_panel(resource_name: 'Upload', scope: @post, uploads: @post.uploads) %>
```

- you can also use the uploader is form fields in your custom form…

```ruby
class Upload < ApplicationRecord
  include Pshr::Uploadable
end
```

```html
<%= form_with model: @upload do |form| %>

  <%= render 'pshr/uploads/fields', form: form %>

  <%= form.submit "Save Upload" %>
<% end %>
```

…or for nested attributes

```ruby
class Post < ApplicationRecord
  has_one :thumb, as: :uploadable, dependent: :destroy
  accepts_nested_attributes_for :thumb, allow_destroy: true,
    reject_if: proc { |attributes| attributes['file'].blank? }
end
```

```html
<%= form_with(model: post, local: true) do |form| %>

  <!-- ... -->

  <%= form.fields_for :thumb do |ff| %>
    <%= pshr_upload_fields ff %>
  <% end %>

  <!-- ... -->
<% end %>
```

## Usage

- Uploads can be ordered per associated record (using [RankedModel](https://github.com/mixonic/ranked-model)):
```ruby
uploads = Pshr::Upload.ordered # query ordered uploads
uploads.first.update_attributes(order_position: :last) # change position with integer, :up, :down, :first and :last
```

- Metadata: You can use the `metadata` column (jsonb) to provide your custom data (e.g. a caption) with the upload. An easy way to manipulate the `metadata` hash using `serialize` and `store_accessor` in your upload model:

```ruby
# app/models/my_upload.rb
class MyUpload < ApplicationRecord
  include Pshr::Uploadable
  serialize :metadata
  store_accessor :metadata, :caption
end
```

As the `metadata` column will be serialized and `:caption` is an accessible attribute, the following form will send the params as `upload: { file: …, metadata: { caption: 'my caption…' } }` and populate the `upload` form accordingly.

```erb
# app/views/uploads/_my_form.html.erb
<%= form_with model: upload, url: main_app.url_for(upload) do |form| %>
  <%= form.hidden_field :uploadable_type, value: form.object.uploadable_type %>
  <%= form.hidden_field :uploadable_id, value: form.object.uploadable_id %>

  <%= form.file_field :file %>

  <%= form.text_field :caption %>

  <%= form.submit "Upload" %>
<% end %>
```


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ToDo

- Install generator for upload models like `rails g pshr:install:model CustomUpload additional:string` with all the necessary fields and additional fields

- setting upload directory and prefix currently doesn't work
