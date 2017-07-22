input_file = File.new("db/laws.tsv", "r")

while line = input_file.gets
  content_split = line.split("\t")
  doc_id = content_split[0]
  content = content_split[1]
  symbol_number = content_split[2]
  public_day = content_split[3]
  if public_day.length > 0
    public_day.gsub!(".", "")
  end
  day_report = content_split[4]
  if day_report.length > 0
    day_report.gsub!(".", "")
  end
  type = content_split[5]
  source = content_split[6]
  scope = content_split[7]
  effect_day = content_split[8]
  if effect_day.length > 0
    effect_day.gsub!(".", "")
  end
  html_content = content_split[9]
  html_content.gsub!("\\n", "")
  html_content.gsub!("\\t", "")
  html_content.gsub!("\\r", "")
  effect_status = content_split[10].split(":")[1]
  effect_status[0] = ""
  title = type + " " + symbol_number

  Article.create! doc_id: doc_id,
    title: title,
    content: content,
    html_content: html_content,
    symbol_number: symbol_number,
    public_day: public_day,
    day_report: day_report,
    article_type: type,
    source: source,
    effect_day: effect_day,
    effect_status: effect_status
end
