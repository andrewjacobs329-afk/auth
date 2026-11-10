class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string "author"
      t.string "body"
      t.string "image"

      t.timestamps
    end
  end
end
