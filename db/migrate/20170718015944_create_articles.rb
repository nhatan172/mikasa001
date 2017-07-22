class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :doc_id, unique: true
      t.text :title
      t.text :content
      t.text :html_content
      t.text :symbol_number
      t.datetime :public_day
      t.datetime :day_report
      t.text :article_type
      t.text :source
      t.text :scope
      t.datetime :effect_day
      t.text :effect_status

      t.timestamps
    end
  end
end
