module RedmineHeaderNumbering
  class TextProcessor
    # Matches only lines starting with at least two '#' characters
    HEADER_REGEX = /^##+.+$/

    def self.process_headers(text)
      header_stack = []
      last_level = 1

      # Scans ONLY for headers. Regular text is skipped entirely.
      text.gsub(HEADER_REGEX) do |matched|
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

        # 5. Return the newly numbered header
        "#{'#' * last_level} #{number} #{header_text}"
      end
    end
  end
end
