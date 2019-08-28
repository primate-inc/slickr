class CreateNewsArticles < ActiveRecord::Migration[5.1]
  def up
    unless ActiveRecord::Base.connection.tables.include?('news_articles')
      create_table :news_articles do |t|
        t.string :slug, index: true
        t.string :title
        t.boolean :featured, default: false, null: false
        t.text :header
        t.text :subheader
        t.string :category
        t.string :header_image
        t.string :thumbnail
        t.text :content
        t.date :date
        t.timestamps
      end
    end
  end
  def down
    if ActiveRecord::Base.connection.tables.include?('news_articles')
      drop_table :news_articles
    end
  end
end

