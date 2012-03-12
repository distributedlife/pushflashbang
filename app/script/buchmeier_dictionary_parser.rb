# -*- encoding : utf-8 -*-
class WicktionaryParser
  @agent 

  def initialize
    @agent = Mechanize.new

    #pretend we are chrome to get around Mechanize being blocked; we must be nice and not smash them and get ourselves blocked
    @agent.user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Ubuntu/10.04 Chromium/12.0.742.112 Chrome/12.0.742.112 Safari/534.30"
  end

  def get page
    @agent.get page
  end
end

class BuchmeierDictionaryParser
  @wik_parser
  @results 

  def initialize
    @wik_parser = WicktionaryParser.new
    @results = []
  end

  def parse language, page
    @results = parse_dictionary_page(page, language)
  end

  def results
    @results
  end

  def parse_dictionary_page name, other_lang
    page = @wik_parser.get "http://en.wiktionary.org/w/index.php?title=User:Matthias_Buchmeier/#{name}&action=edit"

    text = page.search(".//textarea[@id='wpTextbox1']").text
    lines = text.split("\n")

    json = []

    allowed_regions = ["Latin America",
    "Central America",
    "South America",
    "South América",

    "Spain",
    "Dominican Republic",
    "Puerto Rico",
    "Cuba",
    "Costa Rica",
    "Caribbean",

    "Canary Islands",
    "California",

    "Mexico",
    "Mex",
    "Mexican",
    "México",
    "Panama",
    "El Salvador",
    "Guatemala",
    "Honduras",
    "Nicaragua",

    "Venezuela",
    "Colombia",
    "Ecuador",
    "Peru",
    "Bolivia",
    "Paraguay",
    "Uruguay",
    "Argentina",
    "Chile",

    "Castilian",
    "Basque"
    ]

    skip_until_start_marker = true
    ignore = ["|-", "|}", "{|"]
    idiom = nil
    lines.each do |line|
      skip_until_start_marker = false if line == "{|"
      next if skip_until_start_marker
      next if line.empty?
      next if (ignore & [line] == [line])

      #the format of the file is english line, | :: spanish line
      if line["::"]
        #other_lang line, add this to the current idiom
        next if line == "| :: "

        other = Hash.new
        other[:definitions] = []
        line.split(/,[\s]\[/).each_with_index do |definition_line, index|
          definition_line = "[#{definition_line}" if index  > 0     #add the square bracket that gets dropped by the split

          definition = Hash.new
          definition[:form] = []
          definition_line.split(/\[\[([^"]*?)\]\]/imu).each do |form|
            form.strip!
            next if form.empty?
            next if form == "| ::"
            next if form["{"]
            next if form["}"]

            definition[:form] << form.split("|").first
          end
          definition[:type] = []
          definition_line.split(/\{([^"]*?)\}/imu).each do |type_val|
            type_val.strip!
            next if type_val["::"]
            next if type_val["["]
            next if type_val["]"]
            next if type_val.empty?

            definition[:type] << type_val
          end
          definition[:notes] = []
          definition_line.split(/\[([^"]*?)\]/imu).each do |note|
            note.strip!
            next if note.empty?
            next if note["::"]
            next if note["{"]
            next if note["}"]
            next if note["["]
            next if note["]"]

            note.split(',').each do |note_part|
              note_part.strip!
              next if note_part.empty?

#              used = false
              allowed_regions.each do |region|
                if note_part[region]
                  definition[:notes] << region
#                  used = true
                end
              end

#              definition[:notes] << note_part unless used
            end
          end

          other[:definitions] << definition
        end

        idiom[other_lang.to_sym] = other
      else
        json << idiom unless idiom.nil?

        #English and Definition
        idiom = Hash.new
        parts = line.split("SEE:")

        english = Hash.new
        english[:form] = parts.first.scan(/\[\[([^"]*)\]\]/imu).flatten.first
        english[:type] = parts.first.scan(/\{([^"]*)\}/imu).flatten.first
        idiom[:english] = english

        definition = parts.first.scan(/\(([^"]*)\)/imu).flatten.first
        idiom[:definition] = definition.gsub("[", "").gsub("]","") unless definition.nil?

        if parts.count > 1
          share_meaning = nil
          share_meaning = []

          parts.last.split("''or''").each do |related|
            share_meaning << related.scan(/\[\[([^"]*)\]\]/imu).flatten.first
          end

          idiom[:share_meaning] = share_meaning
        end
      end
    end

    json
  end
end
