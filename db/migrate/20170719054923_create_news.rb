class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
    	t.text :doc_title
    	t.text :doc_url
    	t.text :doc_id
    	t.text :doc_description
    	t.text :doc_content
    	t.text :doc_date

      	t.timestamps
    end
  end
end
