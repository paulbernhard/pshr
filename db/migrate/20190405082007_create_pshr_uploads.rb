class CreatePshrUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :pshr_uploads do |t|
      t.text :file_data
      t.jsonb :metadata
      t.integer :order
      t.boolean :processing, default: false
      t.references :uploadable, polymorphic: true

      t.timestamps
    end
  end
end
