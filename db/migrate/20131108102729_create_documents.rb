class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string  :document
      t.integer :documentable_id
      t.string  :documentable_type
      t.timestamps
    end

    add_index(:documents, [ :documentable_id, :documentable_type ])
  end
end