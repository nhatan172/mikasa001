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
      remove_redundant_element

      @parts = @article.parts
      @chapters = @article.chapters.order(chap_name: :asc, part_index: :asc)
      @sections = @article.sections.order(sec_name: :asc, part_index: :asc,
        chap_index: :asc)
      @laws = @article.laws.order(part_index: :asc, chap_index: :asc,
        sec_index: :asc, law_index: :asc)

      parts_size = 0
      chapters_size = 0
      sections_size = 0
      laws_size = 0

      @parts.each do |part|
        parts_size = part.totalpart
        break
      end

      @chapters.each do |chapter|
        chapters_size = chapter.totalchap
        break
      end

      @sections.each do |section|
        sections_size = section.totalsec
        break
      end

      @laws.each do |law|
        laws_size = law.totallaw
        break
      end

      parts_position_list = {}
      chapters_position_list = {}
      @finish_parts__position_list = false

      if parts_size > 0
        parts_position_list = make_parts_position_list
      end

      if chapters_size > 0
        @chapters.each do |chapter|
          if chapter.chap_name != nil
            link_prefix = '<a id="'
            if parts_size > 0
              parts_position_list = make_parts_position_list
              chapters_position_list = make_chapters_position_list_with_part parts_position_list
              link_prefix += 'part' + (chapter.part_index + 1).to_s + '_'
              full_link = link_prefix + 'chapter' +
              (chapter.chap_index + 1).to_s  + '">' + '</a>'
              chapters_position_list.each do |key, values|
                if key.to_s.to_i == chapter.chap_index
                  values.each do |part_index, chap_position|
                    if part_index.to_s.to_i == chapter.part_index
                      @full_html.insert chap_position, full_link
                      break
                    end
                  end
                  break
                end
              end
            else
              index = @full_html.index '<strong>' + chapter.chap_name + '</strong>'
              if index == nil
                index = @full_html.index chapter.chap_name + '</p>'
              end
              if index == nil
                index = @full_html.index chapter.chap_name + '</b></font>'
              end
              if index != nil
                full_link = link_prefix + 'chapter' +
                  (chapter.chap_index + 1).to_s + '">' + '</a>'
                @full_html.insert index, full_link
              end
            end
          end
        end
      end

      chapters_position_list = {}

      if parts_size == 0 
        chapters_position_list = make_chapters_position_list_with_out_part
      else
        chapters_position_list = make_chapters_position_list_with_part parts_position_list
      end

      sections_position_list = {}

      if sections_size > 0
        @sections.each do |section|
          if section.sec_name != nil
            link_prefix = '<a id="'
            parts_position_list = make_parts_position_list
            if parts_size == 0
              chapters_position_list = make_chapters_position_list_with_out_part
            else
              chapters_position_list = make_chapters_position_list_with_part parts_position_list
            end
            sections_position_list = {}
            done = false
            if chapters_size > 0
              @full_html.to_enum(:scan, '<strong>' + section.sec_name + '</strong>').map do |m, |
                #byebug
                chapters_position_list.each do |chap_index, values|
                  before_chap_index = -1
                  before_part_index = -1
                  values.each_with_index do |(part_index, chap_position), index|
                    #byebug
                    if chap_position < $`.size
                      if index == values.length - 1
                        if chap_index.to_s.to_i == section.chap_index and
                          part_index.to_s.to_i == section.part_index
                          sections_position_list[$`.size.to_s.to_sym] = 
                            {"chap_index": chap_index.to_s.to_i,
                            "part_index": part_index.to_s.to_i}
                          done = true
                          break
                        end
                      else
                        if chap_index.to_s.to_i == section.chap_index and
                          part_index.to_s.to_i == section.part_index
                            before_chap_index = chap_index.to_s.to_i
                            before_part_index = part_index.to_s.to_i
                        end
                      end
                    else
                      if before_chap_index == section.chap_index and
                        before_part_index == section.part_index
                          sections_position_list[$`.size.to_s.to_sym] = 
                            {"chap_index": before_chap_index,
                            "part_index": before_part_index}
                          done = true
                          break
                      end
                    end
                  end
                  break if done
                end
                break if done
              end
              if done == false
                @full_html.to_enum(:scan, section.sec_name + '</p>').map do |m, |
                  chapters_position_list.each do |chap_index, values|
                    before_chap_index = -1
                    before_part_index = -1
                    values.each_with_index do |(part_index, chap_position), index|
                      if chap_position < $`.size
                        if index == values.length - 1
                          if chap_index.to_s.to_i == section.chap_index and
                            part_index.to_s.to_i == section.part_index
                            sections_position_list[$`.size.to_s.to_sym] = 
                              {"chap_index": chap_index.to_s.to_i,
                              "part_index": part_index.to_s.to_i}
                            done = true
                            break
                          end
                        else
                          if chap_index.to_s.to_i == section.chap_index and
                            part_index.to_s.to_i == section.part_index
                              before_chap_index = chap_index.to_s.to_i
                              before_part_index = part_index.to_s.to_i
                          end
                        end
                      else
                        if before_chap_index == section.chap_index and
                          before_part_index == section.part_index
                            sections_position_list[$`.size.to_s.to_sym] = 
                              {"chap_index": before_chap_index,
                              "part_index": before_part_index}
                            done = true
                            break
                        end
                      end
                    end
                    break if done
                  end
                  break if done
                end
              end
              if done == false
                @full_html.to_enum(:scan, section.sec_name + '</b></font>').map do |m, |
                  chapters_position_list.each do |chap_index, values|
                    before_chap_index = -1
                    before_part_index = -1
                    values.each_with_index do |(part_index, chap_position), index|
                      if chap_position < $`.size
                        if index == values.length - 1
                          if chap_index.to_s.to_i == section.chap_index and
                            part_index.to_s.to_i == section.part_index
                            sections_position_list[$`.size.to_s.to_sym] = 
                              {"chap_index": chap_index.to_s.to_i,
                              "part_index": part_index.to_s.to_i}
                            done = true
                            break
                          end
                        else
                          if chap_index.to_s.to_i == section.chap_index and
                            part_index.to_s.to_i == section.part_index
                              before_chap_index = chap_index.to_s.to_i
                              before_part_index = part_index.to_s.to_i
                          end
                        end
                      else
                        if before_chap_index == section.chap_index and
                          before_part_index == section.part_index
                            sections_position_list[$`.size.to_s.to_sym] = 
                              {"chap_index": before_chap_index,
                              "part_index": before_part_index}
                            done = true
                            break
                        end
                      end
                    end
                    break if done
                  end
                  break if done
                end
              end
            end
            if parts_size == 0 && chapters_size == 0
              index = @full_html.index '<strong>' + section.sec_name + '</strong>'
              full_link = link_prefix + 'section' +
                (section.sec_index + 1).to_s  + '"></a>'
              @full_html.insert index, full_link
            elsif parts_size > 0 && chapters_size == 0
              sections_position_list.each do |key, value|
                if value["part_index".to_sym] == section.part_index
                  full_link = link_prefix + 'part' +
                    (section.part_index + 1).to_s + '_section' +
                    (section.sec_index + 1).to_s  + '"></a>'
                  @full_html.insert key.to_s.to_i, full_link
                  break
                end
              end
            elsif parts_size == 0 && chapters_size > 0
              sections_position_list.each do |key, value|
                if value["chap_index".to_sym] == section.chap_index
                  full_link = link_prefix + 'chap' +
                    (section.chap_index + 1).to_s + '_section' +
                    (section.sec_index + 1).to_s  + '"></a>'
                  @full_html.insert key.to_s.to_i, full_link
                  break
                end
              end
            elsif parts_size > 0 && chapters_size > 0
              sections_position_list.each do |key, value|
                if value["chap_index".to_sym] == section.chap_index and
                  value["part_index".to_sym] == section.part_index
                    full_link = link_prefix + 'part' +
                      (section.part_index + 1).to_s + 
                      '_chap' + (section.chap_index + 1).to_s +
                      '_section' + (section.sec_index + 1).to_s  + '"></a>'
                    @full_html.insert key.to_s.to_i, full_link
                    break
                end
              end
            end
          end
        end
      end                                                                                                                                                                                            

      if laws_size > 0
        @laws.each_with_index do |law, index|
          index_insert = @full_html.index law.law_name
          @full_html.insert index_insert, '<a id="law' + (index + 1).to_s  + '"></a>'
        end
      end

      mark_part = -1
      mark_chapter = -1
      mark_section = -1
      @laws.each_with_index do |law, index|
        if parts_size != 0 and mark_part != law.part_index
          mark_part = law.part_index
          mark_chapter = -1
          @index_html += '<div class="part_index"><a class="internal_link" href="#part' + 
            (law.part_index + 1).to_s + '">Phần ' + 
            (law.part_index + 1).to_s + '</a></div>'
        end
        if chapters_size != 0 and mark_chapter != law.chap_index
          chapter = @chapters.find_by(part_index: law.part_index, chap_index: law.chap_index)
          if chapter.chap_name != nil
            mark_chapter = law.chap_index
            mark_section = -1
            prefix_link_index = '<div class="chapter_index"><a class="internal_link" href="#'
            if parts_size > 0
              prefix_link_index += 'part' + (law.part_index + 1).to_s + '_'
            end
            full_link_index = prefix_link_index + 'chapter' +
            (law.chap_index + 1).to_s + '">' + 
            chapter.chap_name + '</a></div>'
            @index_html += full_link_index
          end
        end
        if sections_size != 0 and mark_section != law.sec_index
          section = @sections.find_by(part_index: law.part_index,
            chap_index: law.chap_index, sec_index: law.sec_index)
          if section.sec_name != nil and section.sec_name.present?
            mark_section = law.sec_index
            prefix_link_index = '<div class="section_index"><a class="internal_link" href="#'
            if parts_size > 0
              prefix_link_index += 'part' + (law.part_index + 1).to_s + '_'
            end
            if chapters_size > 0
              prefix_link_index += 'chap' + (law.chap_index + 1).to_s + '_'
            end
            full_link_index = prefix_link_index + 'section' +
              (law.sec_index + 1).to_s + '">Mục ' +
              (law.sec_index + 1).to_s + '</a></div>'
            @index_html += full_link_index
          end
        end
        @index_html += '<div class="law_index"><a class="internal_link" href="#law' + 
          (index + 1).to_s + '">' + law.law_name + '</a></div>'
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
          title = get_title(a.position)
          modified_law_id = a.modified_law_id
          html_insert = '<a target="_blank" title="Đi đến văn bản được sửa đổi" href="/articles/' + modified_law_id + '" class="link_modify"><span class="glyphicon glyphicon-share-alt"></span></a>'
          if title != nil
            pattern = convert2regex(title)
            pattern =  eval('"' + pattern + '"')
            pattern = pattern[0,pattern.length]
            pattern =pattern.force_encoding("UTF-8")
            find = /#{pattern}/m.match(@full_html)
            if find != nil
              @full_html = @full_html[0,find.end(0)] + html_insert + @full_html[find.end(0),@full_html.length]
              print '__1__' + pattern + '____'
            else
              print '__2__' + pattern + '____'
            end
          else
            print '__3__' + a.position + '____'
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

  def make_parts_position_list
    if @finish_parts_position_list == false
      @parts.each do |part|
        position = @full_html.index '<strong>' + part.name_part + '</strong>'
        if position == nil
          position = @full_html.index part.name_part + '</p>'
        end
        if position != nil
          @full_html.insert position, '<a id="part' + (part.part_index + 1).to_s  +
            '"></a>'
        end
      end
      @finish_parts_position_list = true
    end
    parts_position_list = {}
    @parts.each do |part|
      position = @full_html.index '<strong>' + part.name_part + '</strong>'
      if position == nil
        position = @full_html.index part.name_part + '</p>'
      end
      if position != nil
        parts_position_list[part.part_index.to_s.to_sym] = position
      end
    end
    parts_position_list = Hash[parts_position_list.sort_by{|key, value| value}]
  end

  def make_chapters_position_list_with_out_part
    chapters_position_list = {}
    pre_chap_name = ''
    @chapters.each do |chapter|
      if chapter.chap_name != nil
        if pre_chap_name == '' || pre_chap_name == chapter.chap_name
          @full_html.to_enum(:scan, '<strong>' + chapter.chap_name + '</strong>').map do |m, |
            if chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
              chapters_position_list[chapter.chap_index.to_s.to_sym][0.to_s.to_sym] =
                $`.size
            else
              chapters_position_list[chapter.chap_index.to_s.to_sym] =
                {0.to_s.to_sym => $`.size}
            end
          end
          @full_html.to_enum(:scan, chapter.chap_name + '</p>').map do |m, |
            if chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
              chapters_position_list[chapter.chap_index.to_s.to_sym][0.to_s.to_sym] =
                $`.size
            else
              chapters_position_list[chapter.chap_index.to_s.to_sym] =
                {0.to_s.to_sym => $`.size}
            end
          end
          @full_html.to_enum(:scan, chapter.chap_name + '</span>').map do |m, |
            if chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
              chapters_position_list[chapter.chap_index.to_s.to_sym][0.to_s.to_sym] =
                $`.size
            else
              chapters_position_list[chapter.chap_index.to_s.to_sym] =
                {0.to_s.to_sym => $`.size}
            end
          end
          @full_html.to_enum(:scan, chapter.chap_name + '</b></font>').map do |m, |
            if chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
              chapters_position_list[chapter.chap_index.to_s.to_sym][0.to_s.to_sym] =
                $`.size
            else
              chapters_position_list[chapter.chap_index.to_s.to_sym] =
                {0.to_s.to_sym => $`.size}
            end
          end
        end
      end
    end
    chapters_position_list = Hash[chapters_position_list.sort_by{|key, value| key}]
  end

  def iterate_full_html_to_extract_chapter search_string, chapter, parts_position_list
    @full_html.to_enum(:scan, search_string).map do |m, |
      before_part_index = -1
      parts_position_list.each_with_index do |(part_index, part_position), index|
        if part_position < $`.size
          if index == parts_position_list.length - 1
            if @chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
              @chapters_position_list[chapter.chap_index.to_s.to_sym][part_index.to_s.to_sym] =
                $`.size
            else
              @chapters_position_list[chapter.chap_index.to_s.to_sym] =
                {part_index.to_s.to_sym =>  $`.size}
            end
            @chapters_position_list[chapter.chap_index.to_s.to_sym] =
              Hash[@chapters_position_list[chapter.chap_index.to_s.to_sym].sort_by{|key, value| value}]
          else
            before_part_index = part_index.to_s.to_i
          end
        else
          if @chapters_position_list[chapter.chap_index.to_s.to_sym] != nil
            @chapters_position_list[chapter.chap_index.to_s.to_sym][before_part_index.to_s.to_sym] =
              $`.size
          else
            @chapters_position_list[chapter.chap_index.to_s.to_sym] =
              {before_part_index.to_s.to_sym =>  $`.size}
          end
          @chapters_position_list[chapter.chap_index.to_s.to_sym] =
            Hash[@chapters_position_list[chapter.chap_index.to_s.to_sym].sort_by{|key, value| value}]
        end
      end
    end
  end

  def make_chapters_position_list_with_part parts_position_list
    @chapters_position_list = {}
    @chapters.each do |chapter|
      if chapter.chap_name != nil
        iterate_full_html_to_extract_chapter '<strong>' + chapter.chap_name + '</strong>',
          chapter, parts_position_list
        iterate_full_html_to_extract_chapter chapter.chap_name + '</p>',
          chapter, parts_position_list
        iterate_full_html_to_extract_chapter chapter.chap_name + '</span>',
          chapter, parts_position_list
        iterate_full_html_to_extract_chapter chapter.chap_name + '</b></font>',
          chapter, parts_position_list
      end
    end
    return @chapters_position_list
  end

  def get_title(string)
    indexSet = string.split('_')
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
      points = @article.points.where(point_index: pointIndex)
      points.each do |point|
        if point.part_index == partIndex && point.chap_index == chapIndex && point.sec_index == secIndex && point.law_index == lawIndex && point.item_index == itemIndex
          return firstStrip(point.point_content)
        end
      end
    elsif itemIndex != nil
      items = @article.items.where(item_index: itemIndex)
      items.each do |item|
        if item.part_index == partIndex && item.chap_index == chapIndex && item.sec_index == secIndex && item.law_index == lawIndex
          return firstStrip(item.item_content)
        end
      end
    elsif
      laws = @article.laws.where(law_index: lawIndex)
      laws.each do |law|
        if law.part_index == partIndex && law.chap_index == chapIndex && law.sec_index == secIndex
          return firstStrip(law.law_content)
        end
      end
    end
    return nil
  end

  def convert2regex(string)
    symbol = ['_','*','#',"\n"]
    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub('\.','.')
    string = string.strip()
    index = 0
    string = string.gsub('(','?')
    string = string.gsub(')','!')
    for i in 0..(string.length-2)
      string = string[0,index] + '(<[^\<]+>)*' + string[index,string.length]
      index += 12
    end
    string = string.gsub('?','\(')
    string = string.gsub('!','\)')
    string = string.gsub("/",'\/')
    string = string.gsub(".","\\.")
    string = string.gsub(/\s/,"\\\\s*")
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
    print "__4__" + string
    return string
  end
end