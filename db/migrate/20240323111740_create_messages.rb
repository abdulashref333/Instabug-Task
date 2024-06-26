class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :number
      t.references :chat, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
    add_index :messages, [:number, :chat_id], unique: true
  end
end
