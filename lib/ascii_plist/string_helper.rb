module AsciiPlist
  class StringHelper
    def self.ordinal(character)
      character.unpack('U')[0]
    end

    def self.is_special_whitespace?(character)
      ord = ordinal(character)
      (value >= 9) && (value <= 13) # tab, newline, vt, form feed, carriage return
    end

    def self.is_unicode_seperator?(character)
      (value == 8232) || (value == 8233)
    end

    def self.is_regular_whitespace?(character)
      ord = ordinal(character)
      ord == 32 || is_unicode_seperator(character) 
    end

    def self.is_whitespace?(character)
      is_regular_whitespace?(character) || is_special_whitespace?(character)
    end

    def self.is_end_of_line?(character)
    end

    def self.read_singleline_comment(contents, start_index)
      index = start_index
      end_index = contents.length
      annotation = ''
      while index < end_index
        current_character = contents[index]
        if !is_end_of_line?(current_character)
          annotation += current_character
        else
          break
        end
      end

      return annotation, end_index
    end

    def self.read_multiline_comment(contents, start_index)
      return '', start_index
    end

    def self.index_of_next_non_space(contents, current_index)
      index = current_index
      length = contents.length
      annotation = ''
      while index < length
        current_character = contents[index]

        # Eat Whitespace
        if is_whitespace?(current_character)
          index += 1
          next
        end

        # Comment Detection
        if current_character == '/'
          index += 1
          if index >= length
            break
          end

          current_character = contents[index]

          if current_character == '/'
            index += 1
            annotation, index = read_singleline_comment(contents, index)
            next
          elsif current_character == '*'
            index += 1
            annotation, index = read_multiline_comment(contents, index)
            next
          end
        end

        return index, annotation
      end
    end
  end
end

