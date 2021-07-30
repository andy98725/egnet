class CreateDownloads < ActiveRecord::Migration[6.0]
  def change
    create_table :downloads do |t|
      t.text :IP
      t.integer :Target
      t.text :System

      t.timestamps
    end
  end
end
