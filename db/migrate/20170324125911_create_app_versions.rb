class CreateAppVersions < ActiveRecord::Migration
  def change
    create_table :app_versions do |t|
      t.integer  :code, null: false, default: 1
      t.string   :name, null: false, comments: "version name"
      t.integer  :mobile_system, null: false, comments: "1 android, 2 ios"
      t.text     :content, limit: 500, null: false, comments: "version update contents"

      t.datetime :created_at
    end

    add_index :app_versions, [:code, :mobile_system], using: :btree, unique: true
    add_index :app_versions, [:name, :mobile_system], using: :btree, unique: true
  end
end