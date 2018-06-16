class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.text "contents"
      t.string "ip_address"

      t.timestamps
    end
  end
end
