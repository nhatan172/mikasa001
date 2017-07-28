class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
    	t.text :doc_id, unique: true
      t.text :title
    	t.text :url
    	t.text :description
    	t.text :content
    	t.text :public_date

      t.timestamps
    end
  end
end
