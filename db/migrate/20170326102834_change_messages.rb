class ChangeMessages < ActiveRecord::Migration
  def change
    add_column :messages, :avatar_path, :string
    add_column :messages, :gif_path, :string
  	add_column :messages, :ori_picture_urls, :text, limit: 500, comments: "store ys7 capture picture url"
  end
end