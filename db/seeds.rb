input_file = File.new("db/laws.tsv", "r")

while line = input_file.gets
  content_split = line.split("\t")
  doc_id = content_split[0]
  content = content_split[1]
  html_content = content_split[2]
  Article.create! doc_id: doc_id,
    content: content,
    html_content: html_content
end