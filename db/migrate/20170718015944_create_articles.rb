class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :doc_id
      t.text :content
      t.text :html_content

      t.timestamps
    end
  end
end
