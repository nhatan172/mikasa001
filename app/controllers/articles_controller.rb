class ArticlesController < ApplicationController
  before_action :get_article, only: [:show]
  before_action :render_index_html, only: [:show]
  def show
    count = @article.count_click + 1
    @article.update_attributes count_click: count
  end

  def index
    @articles = Article.paginate page: params[:page]
  end
  private

  def get_article
    @article = Article.find_by id: params[:id]
  end

  def render_index_html
    if @article.content.length > 0 &&
        (@article.index_html == nil || @article.index_html.length == 0)
      @index_html = ''
      @full_html =''
      remove_redundant_element

      @parts = @article.parts.order(part_index: :asc)
      @start_index = 0
      @parts.each do |part|
        if part.totalpart > 0
          #insert part link
          insert_big_tag(part, 1)
        end

        chapters = part.chapters
        chapters.each do |chapter|
          if chapter.totalchap > 0
            #insert chap link
            insert_big_tag(chapter, 2)
          end

          secs = chapter.sections
          secs.each do |sec|
            if sec.totalsec > 0
              #insert chap link
              insert_big_tag(sec, 3)
            end

            laws = sec.laws
            laws.each do |law|
              if law.totallaw> 0
                #insert link
                insert_big_tag(law, 4)
              end

              items = law.items
              items.each do |item|
                if item.totalitem > 0
                  #insert link
                  insert_small_tag(item, 1)
                end

                points = item.points
                points.each do |point|
                  if point.totalpoint > 0
                    #insert link
                    insert_small_tag(point, 2)
                  end
                end
              end
            end
          end
        end
      end
      ########
      if @article.isLawModify?
        @modifies = @article.relationshipmodifies
        browsed = []
        @modifies.each do |a|
          if browsed.include? a.position 
            next
          end
          browsed.push(a.position)
          title = firstStrip(get_title(@article,a.position))
          modified_law_id = a.modified_law_id
          html_insert = '<a target="_blank" title="Đi đến văn bản được sửa đổi" href="/articles/' + modified_law_id + '#'+sumary_to_position(a)+'" class="link_modify"><span class="glyphicon glyphicon-share-alt"></span></a>'
          if title != nil
            pattern = convert2regex(title)
            find = /#{pattern}/m.match(@full_html)
            if find != nil
              @full_html = @full_html[0,find.end(0)] + html_insert + @full_html[find.end(0),@full_html.length]
            end
          end
        end
      end
      #######
      if @article.isModifedLaw?
        @reverse_relationshipmodifies = @article.reverse_relationshipmodifies
        @reverse_relationshipmodifies.each do |a|
          position = sumary_to_position(a)
          law_modifies = Article.where(id: a.law_id)
          law_modify = nil
          for l in law_modifies
            law_modify = l
            break
          end
          pattern = '<a name="' + position + '"></a>'
          find = /#{pattern}/.match(@full_html)
          if find != nil
            type = law_modify.article_type
            title = law_modify.title
            post = a.position
            ll_id = law_modify.id
            public_day = law_modify.public_day.to_formatted_s(:long)
            content = get_title(law_modify,a.position).to_s
            content = reform_html(content)
            insert_html = '<div class="modifed_outer"> <div class="modified_info"><div class="modified_info_content"><span class="close_modified_info">&times;</span><p>Được sửa đổi, bổ sung tại <a target="_blank" href="/articles/'
            insert_html += ll_id +'#'+ post + '">' + type  + ' ' + title + '</a></p><p>Ban hành ngày: '
            insert_html +=  public_day +'</p><p>Nội dung sửa đổi: </p><p class = "content_modified"> '+ content +'</p></div></div>'
            insert_html += '<span class="glyphicon glyphicon-tags" id="mark_modifed"></span></div>'
            @full_html = @full_html[0,find.begin(0)] + insert_html + @full_html[find.begin(0),@full_html.length]
          end
        end
      end
      #######
      @article.update_attributes(index_html: @index_html)
      @article.update_attributes(full_html: @full_html)
    end
  end
  
  def remove_redundant_element
    link_regex = /\<a\sname\=\"([p|P]han\_\w*\S*)*(\_*[c|C]huong\_\w{1,})*(\_*[m|M]uc\_\d{1,})*(\_*[D|d]ieu\_\d{1,})*\"\>\<\/\w\>/
    
    @full_html = @article.full_html
    @full_html.gsub!(link_regex, '')
    @full_html.gsub!('\n', '')
    @full_html.gsub!('\r', '')
    @full_html.gsub!('\t', '')
  end

  def get_title(article ,post)
    indexSet = post.split('_')
    partIndex = nil
    chapIndex = nil
    secIndex = nil
    lawIndex = nil
    itemIndex = nil
    pointIndex = nil

    (1..indexSet.length).each do |x|
      case x
        when 1
          partIndex = indexSet[0].to_i == 0? nil : indexSet[0].to_i - 1
        when 2
          chapIndex = indexSet[1].to_i == 0? nil : indexSet[1].to_i - 1
        when 3
          secIndex = indexSet[2].to_i == 0? nil : indexSet[2].to_i - 1
        when 4
          lawIndex = indexSet[3].to_i == 0? nil : indexSet[3].to_i - 1
        when 5
          itemIndex = indexSet[4].to_i == 0? nil : indexSet[4].to_i - 1
        when 6
          pointIndex = indexSet[5].to_i == 0? nil : indexSet[5].to_i - 1
      end
    end
    if lawIndex == nil
      return nil
    end
    if pointIndex != nil
      points = article.points.where(point_index: pointIndex)
      points.each do |point|
        if point.part_index == partIndex && point.chap_index == chapIndex && point.sec_index == secIndex && point.law_index == lawIndex && point.item_index == itemIndex
          return point.point_content
        end
      end
    elsif itemIndex != nil
      items = article.items.where(item_index: itemIndex)
      items.each do |item|
        if item.part_index == partIndex && item.chap_index == chapIndex && item.sec_index == secIndex && item.law_index == lawIndex
          return item.item_content
        end
      end
    elsif
      laws = article.laws.where(law_index: lawIndex)
      laws.each do |law|
        if law.part_index == partIndex && law.chap_index == chapIndex && law.sec_index == secIndex
          return law.law_content
        end
      end
    end
    return nil
  end
  def reform_html(string)
    symbol = ['_','*','#','\.']
    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub(/\n/,'<br>')
  end
  def convert2regex(string)
    string =  eval("string")
    string = string.force_encoding("UTF-8")
    symbol = ['_','*','#',"\n"]
    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub('\.','.')
    string = string.strip()
    index = 1
    string = string.gsub('(','?')
    string = string.gsub(')','!')
    for i in 1..(string.length-2)
      string = string[0,index] + '(<[^<]+>)*' + string[index,string.length]
      index += 11
    end
    string = string.gsub('?','\\(')
    string = string.gsub('!','\\)')
    string = string.gsub("/",'\/')
    string = string.gsub(".","\\.")
    string = string.gsub(/\s/,'\s+')
    return string
  end

  def firstStrip(string)
    find = /^(\n|\s)+/.match(string)
    if find != nil
      string = string[find.end(0),string.length]
    end
    find = /\n/.match(string)
    if find != nil
      string = string[0,find.begin(0)]
    end
    return string
  end

  def insert_big_tag (object, type)
    position = ""
    case type
      when 1
        position = "#{object.part_index+1}_0_0_0_0_0"
        insert_html_tag(object.name_part,object.name_part,position,'part_index',true)
      when 2
        position = "#{object.part_index+1}_#{object.chap_index+1}_0_0_0_0"
        insert_html_tag(object.chap_name,object.chap_name,position,'chap_index',true)
      when 3
        position = "#{object.part_index+1}_#{object.chap_index+1}_#{object.sec_index+1}_0_0_0"
        insert_html_tag(object.sec_name,object.sec_name,position,'sec_index',true)
      when 4
        position = "#{object.part_index+1}_#{object.chap_index+1}_#{object.sec_index+1}_#{object.law_index+1}_0_0"
        insert_html_tag(firstStrip(object.law_content),object.law_name,position,'law_index',true)
      end
  end

  def insert_small_tag (object, type)
    position = ""
    case type
      when 1
        position = "#{object.part_index+1}_#{object.chap_index+1}_#{object.sec_index+1}_#{object.law_index+1}_#{object.item_index+1}_0"
        insert_html_tag(firstStrip(object.item_content) ,object.item_name,position,'item_index', false)
      when 2
        position = "#{object.part_index+1}_#{object.chap_index+1}_#{object.sec_index+1}_#{object.law_index+1}_#{object.item_index+1}_#{object.point_index+1}"
        insert_html_tag(firstStrip(object.point_content) ,object.point_name,position,'point_index', false)
      end
  end

  def insert_html_tag (string, name, position, type, style)
    pattern = '\s*(<[^<]+>)\s*' + convert2regex(string) + '\s*(<[^<]+>)\s*'
    find = /#{pattern}/.match(@full_html[@start_index,@full_html.length])
    if find != nil
      html_insert = '<a id="' + position + '"></a>'
      @full_html = @full_html[0,@start_index+find.begin(0)] + html_insert + @full_html[@start_index + find.begin(0),@full_html.length]
      @start_index = find.begin(0)
      if style == true
        @index_html +=  '<div class="'+type+'"><a class="internal_link" href="#' + position + '">' +name+'</a></div>'
      end
    end
  end

  def sumary_to_position(object)
    if  object.part_modify_index != nil
      part_index =  object.part_modify_index + 1
    else 
      part_index = 0
    end

    if  object.chap_modify_index != nil
      chap_index =  object.chap_modify_index + 1
    else 
      chap_index = 0
    end

    if  object.sec_modify_index != nil
      sec_index =  object.sec_modify_index + 1
    else 
      sec_index = 0
    end

    if  object.law_modify_index != nil
      law_index =  object.law_modify_index + 1
    else 
      law_index = 0
    end

    if  object.item_modify_index != nil
      item_index =  object.item_modify_index + 1
    else 
      item_index = 0
    end

    if  object.point_modify_index != nil
      point_index =  object.point_modify_index + 1
    else 
      point_index = 0
    end
    #part_index =?  object.part_modify_index+1 : 0
    # chap_index = object.chap_modify_index >= 0?  object.chap_modify_index+1 : 0
    # sec_index = object.sec_modify_index >= 0?  object.sec_modify_index+1 : 0
    # law_index = object.law_modify_index >= 0?  object.law_modify_index+1 : 0
    # item_index = object.item_modify_index >= 0?  object.item_modify_index +1 : 0
    # point_index = object.point_modify_index>= 0?  object.point_modify_index +1 : 0
    return position = "#{part_index}_#{chap_index}_#{sec_index}_#{law_index}_#{item_index}_#{point_index}"
  end

end