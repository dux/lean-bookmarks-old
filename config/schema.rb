# t.rename :old_field_name, :new_field_name
# t.timestamps
# t.polymorphic :grp
# t.add_index :created_by
# rest same as rails schema

AutoMigrate.migrate do

  table :logs do |t|
    t.string   "kind"
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at"
    t.polymorphic :grp
  end

  table :buckets do |t|
    t.string   "name",          null: false
    t.text     "description"
    t.boolean  "active",        default: true
    t.string   "tags",          array: true
    t.integer  "child_buckets", array: true
    t.string   "template"
    t.string   "image"
    t.timestamps

    t.add_index :created_by
  end

  table :links do |t|
    t.string   "name",       null: false
    t.string   "url",        null: false
    t.string   "domain",     null: false
    t.string   "tags",       array: true
    t.string   "kind"
    t.string   "description"
    t.boolean  "active",     default: true
    t.boolean  "is_article", default: false
    t.integer  "bucket_id",  null: false
    t.timestamps

    t.add_index :created_by
  end

  table :notes do |t|
    t.string   "name",        null: false
    t.text     "data"
    t.integer  "bucket_id",   null: false
    t.boolean  "active",      default: true
    t.string   "tags",        array: true
    t.timestamps
  end

  # table :comments do |t|
  #   t.datetime "created_at",  null: false
  #   t.integer  "created_by",  null: false
  #   t.datetime "updated_at",  null: false
  #   t.integer  "updated_by",  null: false
  #   t.text     "data",        null: false
  #   t.integer  "grp_id",      null: false
  #   t.string   "grp_type",    null: false
  # end

  table :domains do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.boolean  "is_article"
    t.datetime "created_at",  null:true
    t.datetime "updated_at",  null:true
    t.integer  "created_by",  null:true, index:true
  end

  # Domain.update_all('updated_at=now() where created_at is null')
  # Domain.update_all('created_by=1 where created_by is null')

  table :users do |t|
    t.string   "name",       limit: 140
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.string   "avatar"
    t.boolean  "active"
    t.string   "pass"
    t.string   "connect_via"
    t.string   "description"
    t.string   "token"
  end
end

# add_index "users", ["email"], name: "index_users_on_email", using: :btree
