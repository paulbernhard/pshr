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
- hook upload model to a parent model with

```ruby
class Post < ApplicationRecord
  has_many :uploads, as: :uploadable, class_name: '::Pshr::Upload'
end
```

## Processing
- enable processing in initializer
- use a custom processor (per model)

## Usage

- Uploads can be ordered per associated record (using [RankedModel](https://github.com/mixonic/ranked-model)):
```ruby
uploads = Pshr::Upload.ordered # query ordered uploads
uploads.first.update_attributes(order_position: :last) # change position with integer, :up, :down, :first and :last
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
