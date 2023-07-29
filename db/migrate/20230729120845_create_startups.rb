class CreateStartups < ActiveRecord::Migration[7.0]
  def change
    create_table :startups do |t|
      t.string :logo
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
