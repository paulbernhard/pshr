class CreateCustomUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_uploads do |t|
      t.text :file_data
      t.jsonb :metadata, default: {}
      t.integer :order
      t.boolean :processing
      t.references :uploadable, polymorphic: true

      t.timestamps
    end
  end
end
