module DeckHelper
  def is_pronunciation_on_front? side
    return side == 'front'
  end

  def is_pronunciation_on_back? side
    return side == 'back'
  end

  def deck_subtitle deck
    text = [] ;

    if deck.shared
      text = text + ["shared"] ;
    end

    if deck.supports_written_answer
      text = text +  ["typed"]
    end

    text = text + ["pn. on #{deck.pronunciation_side}"]


    "(#{text.join(', ')})"
  end

  def get_helper_array
    pronunciation_helper = {}
    #consonants
    pronunciation_helper["b"] = "<em>b</em>oy"
    pronunciation_helper["c"] = "ea<em>ts</em>"
    pronunciation_helper["ch"] = "<em>ch</em>ildren"
    pronunciation_helper["d"] = "<em>d</em>ig"
    pronunciation_helper["f"] = "<em>f</em>ood"
    pronunciation_helper["g"] = "<em>g</em>ood"
    pronunciation_helper["h"] = "<em>h</em>ot"
    pronunciation_helper["j"] = "<em>j</em>eep"
    pronunciation_helper["k"] = "<em>k</em>id"
    pronunciation_helper["l"] = "<em>l</em>oud"
    pronunciation_helper["m"] = "<em>m</em>other"
    pronunciation_helper["n"] = "<em>n</em>imble"
    pronunciation_helper["ng"] = "so<em>ng</em>"
    pronunciation_helper["p"] = "<em>p</em>ine"
    pronunciation_helper["q"] = "<em>ch</em>eat"
    pronunciation_helper["r"] = "<em>r</em>aw"
    pronunciation_helper["t"] = "<em>t</em>alk"
    pronunciation_helper["s"] = "<em>s</em>on"
    pronunciation_helper["sh"] = "<em>sh</em>ake"
    pronunciation_helper["w"] = "<em>w</em>e"
    pronunciation_helper["x"] = "<em>s</em>ee/<em>sh</em>e"
    pronunciation_helper["y"] = "<em>y</em>ou"
    pronunciation_helper["z"] = "wor<em>ds</em>"
    pronunciation_helper["zh"] = "slu<em>dg</em>e"

    #vowels
    pronunciation_helper["a"] = "has_rules"
    pronunciation_helper["e"] = "has_rules"
    pronunciation_helper["ī"] = "has_rules"
    pronunciation_helper["o"] = "has_rules"
    pronunciation_helper["u"] = "l<em>oo</em>k"
    pronunciation_helper["ǚ"] = "r<em>u</em>e"

    #combinational vowels
    pronunciation_helper["ai"] = "<em>eye</em>"
    pronunciation_helper["ao"] = "h<em>ow</em>"
    pronunciation_helper["ei"] = "b<em>ay</em>"
    pronunciation_helper["ia"] = "<em>ea</em>r"
    pronunciation_helper["ie"] = "<em>air</em>"
    pronunciation_helper["iu"] = "y<em>ou</em>"
    pronunciation_helper["ou"] = "l<em>ow</em>"
    pronunciation_helper["ua"] = "g<em>ua</em>va"
    pronunciation_helper["ui"] = "<em>way</em>"
    pronunciation_helper["un"] = "<em>wun</em>"
    pronunciation_helper["uo"] = "<em>wa</em>ll"
    pronunciation_helper["üa"] = "<em>wa</em>"
    pronunciation_helper["üe"] = "<em>we</em>t"
    pronunciation_helper["iao"] = "m<em>eow</em>"
    pronunciation_helper["uai"] = "<em>why</em>"

    #sorted by length
    pronunciation_helper = pronunciation_helper.sort_by {|x| x[0].each_char.count}
    pronunciation_helper.reverse!
    pronunciation_helper
  end

  def string_in_array string, array
    ([string] & array) == [string]
  end

  def get_word_length word
    word.each_char.count
  end

  def get_size_in_bytes char
    char.size
  end

  def multibyte_to_array string
    string.split ""
  end

  def is_first_character i
    i == 0
  end

  def is_last_character i, word
    i == (word.each_char.count - 1)
  end

  def get_char word, i
    multibyte_to_array(word)[i]
  end

  def get_pronunciation_expansion word
    pronunciation_helper = get_helper_array

    a_variations = ["ā", "á", "ǎ", "à", "a"]
    e_variations = ["e", "ē", "é", "ě", "è"]
    i_variations = ["ī", "í", "ǐ", "ì", "i"]
    o_variations = ["o", "ō", "ó", "ǒ", "ò"]
    u_variations = ["u", "ū", "ú", "ǔ", "ù"]
#, "ǚ"

    string = []

    current_word_offset = 0
    word_size = get_word_length word

    while current_word_offset < word_size do
      matched = false
      updated = false
      pronunciation_helper.each do |helper|
        helper_length = get_word_length helper[0]

        next if current_word_offset + helper_length > word_size

        multibyte_to_array(helper[0]).each_with_index do |element, i|
          current_character = get_char(word, current_word_offset + i)


          #is the current character a vowel and therefore needing special treatment?
          current_is_a_variation = string_in_array current_character, a_variations
          current_is_e_variation = string_in_array current_character, e_variations
          current_is_i_variation = string_in_array current_character, i_variations
          current_is_o_variation = string_in_array current_character, o_variations
          current_is_u_variation = string_in_array current_character, u_variations


          #next helper we are a vowel and not in the vowel set
          helper_is_a_variation = string_in_array element, a_variations
          helper_is_e_variation = string_in_array element, e_variations
          helper_is_i_variation = string_in_array element, i_variations
          helper_is_o_variation = string_in_array element, o_variations
          helper_is_u_variation = string_in_array element, u_variations
          
          variation_match = (
            (helper_is_a_variation == current_is_a_variation and helper_is_a_variation) or
            (helper_is_e_variation == current_is_e_variation and helper_is_e_variation) or
            (helper_is_i_variation == current_is_i_variation and helper_is_i_variation) or
            (helper_is_o_variation == current_is_o_variation and helper_is_o_variation) or
            (helper_is_u_variation == current_is_u_variation and helper_is_u_variation)
          )


          #next helper if element is a consonant and not matching
          break unless current_character == element or variation_match


          #the look forward and back rules only apply to single character helpers
          if current_is_a_variation and helper_length == 1
            #the a character has a look back, look forward rule
            prev_char = get_char(word, current_word_offset - 1) unless is_first_character(current_word_offset)
            next_char = get_char(word, current_word_offset + 1) unless is_last_character(current_word_offset, word)

            if prev_char.nil? or next_char.nil?
              string << "m<em>a</em>"
            else
              if string_in_array prev_char, i_variations and next_char == "n"
                string << "c<em>a</em>sh"
              else
                string << "m<em>a</em>"
              end
            end

            matched = true
            updated = true
            current_word_offset = current_word_offset + 1
          end
          if current_is_e_variation and helper_length == 1
            #the e character has a look back
            prev_char = get_char(word, current_word_offset - 1) unless is_first_character(current_word_offset)

            if prev_char.nil?
              string << "<em>e</em>arn"
            else
              if string_in_array prev_char, i_variations + u_variations
                string << "g<em>e</em>t"
              else
                string << "<em>e</em>arn"
              end
            end

            matched = true
            updated = true
            current_word_offset = current_word_offset + 1
          end
          if current_is_i_variation and helper_length == 1
            #the e character has a look back
            prev_char = get_char(word, current_word_offset - 1) unless is_first_character(current_word_offset)
            prev_prev_char = get_char(word, current_word_offset - 2) unless is_first_character(current_word_offset - 1)

            if prev_char.nil? and prev_prev_char.nil?
              string << "s<em>i</em>t"
            else
              if prev_prev_char.nil?
                # could be zi, ci, si or ri
                if prev_char == "z" or prev_char == "c" or prev_char == "s" 
                  string << "<em>i</em> like a buzzing bee"
                elsif prev_char == "r"
                  string << "vocalised <em>r</em>"
                else
                  string << "s<em>i</em>t"
                end
              else
                # could be zhi, chi, shi
                if (prev_prev_char == "z" or prev_prev_char == "c" or prev_prev_char == "s") and prev_char == "h"
                  string << "vocalised <em>r</em>"
                else
                  string << "s<em>i</em>t"
                end
              end
            end

            matched = true
            updated = true
            current_word_offset = current_word_offset + 1
          end
          if current_is_o_variation and helper_length == 1
            #the e character has a look back
            next_char = get_char(word, current_word_offset + 1) unless is_last_character(current_word_offset, word)
            next_next_char = get_char(word, current_word_offset + 2) unless is_last_character(current_word_offset + 1, word)

            if next_char.nil? or next_next_char.nil?
              string << "dr<em>o</em>p"
            else
              if next_char == "n" and next_next_char == "g"
                string << "s<em>o</em>w"
              else
                string << "dr<em>o</em>p"
              end
            end

            matched = true
            updated = true
            current_word_offset = current_word_offset + 1
          end
          break if matched


          next if i < (helper_length - 1)

          matched = true if is_last_character i, helper[0]
        end


        
        if matched and !updated
          string << helper[1]

          current_word_offset = current_word_offset + helper_length
        end

        break if matched
      end


      unless matched 
        string << get_char(word, current_word_offset)

        current_word_offset = current_word_offset + 1
      end
    end

    string.compact!
    string.join(", ")
  end

  def pronunciation_expansion word
    pronunciation_helper = get_helper_array

    a_variations = ["ā", "á", "ǎ", "à", "a"]
    e_variations = ["e", "ē", "é", "ě", "è"]
    i_variations = ["ī", "í", "ǐ", "ì", "i"]
    o_variations = ["o", "ō", "ó", "ǒ", "ò"]
    u_variations = ["u", "ū", "ú", "ǔ", "ù", "ǚ"]

    word_size_stack = [] #this keeps track of the size of each of the previous characters (we be in utf8 biatch!)
    string = "" #what we are going to display

    word.each_char.each_with_index do |char, i|
      word_size_stack << char.size
      matched = false

      pronunciation_helper.each do |index|
        if char == index[0]
          #we have a match; so lets get the helper text

          #the a's have a look back/look forward to determine which a to use
          if string_in_array index[0], a_variations

            # the a variation is surrounded to skip the first and last characters
            if is_first_character i or is_last_character i, word
              string << "m<em>a</em>"  << " "
              matched = true
            end

            break if matched


            prev_char = get_char word, i - 1
            next_char = get_char word, i + 1
#            next_char = word[i + char.size].chr
            if string_in_array(prev_char, i_variations) && next_char == "n"
              string << "c<em>a</em>sh"  << " "
            else
              string << "m<em>a</em>"  << " "
            end

            matched = true
          end


          
          #the e's have a look forward to determine which e to use
          if string_in_array index[0], e_variations
            # the r variation is only preceeded to skip the first character
            if is_first_character i
              string << "<em>e</em>arn" << " "
              matched = true
            end

            break if matched


            prev_char = get_char word, i - 1
#            prev_char = word[i - word_size_stack[-2]].chr
            if string_in_array(prev_char, i_variations) or string_in_array(prev_char, u_variations)
              string << "g<em>e</em>t" << " "
            else
              string << "<em>e</em>arn" << " "
            end

            matched = true
          end



          #the i's have a look back to determine which i to use
          if string_in_array index[0], i_variations
            # the i variation is only preceeded to the first and maybe the second character
            if is_first_character i
              string << "s<em>i</em>t" << " "
              matched = true
            end

            break if matched


            #check one character back first [zi, ci, si, ri]
            prev_char = get_char word, i - 1
#            prev_char = word[i - word_size_stack[-2]].chr
            if prev_char == 'z' or prev_char == 'c' or prev_char == 's'
              string << "<em>i</em> like a buzzing bee" << " "
              matched = true
            elsif prev_char == 'r'
              string << "i like a vocalised <em>r</em>" << " "              
              matched = true
            end
            break if matched


            #it may be a two character look back [zhi, chi, shi]
            #skip if we are character 2
            if word_size_stack.count == 2
              string << "s<em>i</em>t" << " "
              matched = true
            end
            break if matched


            #lets look back
            first_char = word[i - word_size_stack[-3]].chr
            second_char = word[i - word_size_stack[-2]].chr
            if (first_char == 'z' or first_char == 'c' or first_char == 's') and second_char == 'h'
              string << "i like a vocalised <em>r</em>" << " "
            else
              string << "s<em>i</em>t" << " "
            end
            matched = true
          end



          #the o's have a look forward to determine which o to use
          if string_in_array index[0], o_variations
            # the o variation is followed by two characters
            if is_last_character i, word
              string << "dr<em>o</em>p"  << " "
              matched = true
            end

            break if matched


#            next_char = word[i + char.size].chr
#            next_char = get_next_char i, word, word_size_stack[-1]
            next_char = get_char word, i + 1
            next_char = get_char word, i + 2
#            next_next_char = get_next_char i, word, word_size_stack[-1] + next_char.size
#            next_next_char = word[i + char.size + next_char.size].chr
            if next_char == "n" and next_next_char == "g"
              string << "s<em>o</em>w"  << " "
            else
              string << "dr<em>o</em>p"  << " "
            end

            matched = true
          end

        
          break if matched
          
          string << index[1] << " "
        end

        break if matched
      end
    end
    
    string
  end
end
