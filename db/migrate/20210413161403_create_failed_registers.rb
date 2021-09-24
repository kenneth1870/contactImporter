class CreateFailedRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :failed_registers do |t|
      t.text :error
      t.references :import_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
