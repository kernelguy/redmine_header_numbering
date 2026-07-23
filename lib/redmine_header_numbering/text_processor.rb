module RedmineHeaderNumbering
  class TextProcessor

    def self.process_headers(text)
      header_stack = []
      last_level = 1
      header_map = Hash.new

      # Scans ONLY for headers, level 2 or deeper, or the {{number_headers}} faker macro. Regular text is skipped entirely.
      text.gsub(/^(?:(##+ [^\r\n]+)|({{number_headers}}))(?=\r?$)/) do |matched|
        puts "[DEBUG] header matched: #{matched.inspect}"

        if matched == '{{number_headers}}'
          ""
        else
          # 1. Split the line into two parts by the first space:
          #    "## Header ### 2" becomes ["##", "Header ### 2"]
          hashes, remainder = matched.split(' ', 2)

          # 2. Count ONLY the leading hashes
          new_level = hashes.length
          index = new_level - 2

          # 3. Clean the remaining text (spaces only, hashes inside are preserved)
          header_text = remainder.to_s.strip

          # 4. Update the numbering stack
          if new_level < last_level
            header_stack = header_stack[0..index]
            header_stack[index] = header_stack[index].to_i + 1
          elsif new_level == last_level
            header_stack[index] = header_stack[index].to_i + 1
          else
            header_stack += Array.new(new_level - last_level, 1)
          end

          number = header_stack.join('.')
          last_level = new_level
          header_map[TextProcessor.format_reference(header_text)] = number

          # 5. Return the newly numbered header
          "#{'#' * last_level} #{number} #{header_text}"
        end
      end

      text.gsub(/\[(.*)\]\(#([a-zA-Z0-9-_]+)\)/) do |matched|
        puts "[DEBUG] link matched: #{matched.inspect}"
        if header_map.inside(matched.captures[2])
          num_prefix = number.delete('.')
          "[#{number}](##{num_prefix}-#{matched.captures[2]})"
        else
          ""
        end
      end
    end

    def self.format_reference(text)
      no_spaces = text.gsub(/.*(\s+).*/, '-')
      no_dots = no_spaces.delete('.')
      puts "[DEBUG] formatted: #{no_dots}"
      no_dots
    end
  end
end
