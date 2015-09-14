# t.rename :old_field_name, :new_field_name
# t.timestamps
# t.polymorphic :grp
# rest same as all others

AutoMigrate.migrate do

  table :buckets do |t|
    t.rename :image2, :image3

    t.string   "name",          null: false
    t.text     "description"
    t.boolean  "active",        default: true
    t.string   "tags",          array: true
    t.integer  "child_buckets", array: true
    t.string   "template"
    t.string   "image"
    t.string   "image3"
    t.timestamps
  end

  table :links do |t|
    t.string   "name",       null: false
    t.string   "url",        null: false
    t.string   "domain",     null: false
    t.string   "tags",       array: true
    t.string   "kind"
    t.string   "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
    t.boolean  "is_article", default: false
    t.integer  "bucket_id",  null: false
  end

  table :notes do |t|
    t.string   "name",        null: false
    t.text     "data"
    t.datetime "created_at",  null: false
    t.integer  "created_by",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "updated_by",  null: false
    t.integer  "bucket_id",   null: false
    t.boolean  "active",      default: true
    t.string   "tags",        array: true
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
    t.datetime "created_at",  null: false
    t.integer  "created_by",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.boolean  "is_article"
  end

  table :logs do |t|
    t.string   "kind"
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "grp_id",     index:true
    t.string   "grp_type",   index:true
  end

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
  end
end

# add_index "users", ["email"], name: "index_users_on_email", using: :btree
