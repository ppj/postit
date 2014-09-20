class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body

      t.references :user, index: true  # this line adds a foreign-key column called `user_id`
      t.references :post, index: true  # this line adds a foreign-key column called `post_id`

      t.timestamps
    end
  end
end
