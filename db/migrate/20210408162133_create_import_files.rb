class CreateImportFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :import_files do |t|
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
