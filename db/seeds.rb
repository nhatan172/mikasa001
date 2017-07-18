input_file = File.new("db/laws.tsv", "r")

while line = input_file.gets
  doc_id = line.split("\t")[0]
  content = line.split("\t")[1]
  Article.create! doc_id: doc_id,
    content: content
end