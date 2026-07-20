module RedmineHeaderNumbering
  class TextProcessor
    HEADER_REGEX = /^##+/.freeze unless defined?(HEADER_REGEX)

    def self.process_headers(text)
      puts "[DEBUG] TextProcessor.process_headers(#{text})"

      header_stack = []  # Tracks counters for each level (e.g., [1, 1] for h2 > h3)
      last_level = 1     # Tracks the last header level processed. Start at one, because we skip level 1

      text.gsub!(/(^.+$)/) do |line|
        if line.include?('{{number_headers}}')
          line.gsub('{{number_headers}}', '')  # Remove the macro from output

        elsif line.start_with?('##')  # Only process level 2+ headers
          # Extract header level (e.g., '##' -> 2, '###' -> 3)
          new_level = line.match(HEADER_REGEX)[0].length
          index = new_level - 2

          # Extract header text
          header_text = line.sub(HEADER_REGEX, '').strip

          # Adjust the stack for the current level
          if new_level < last_level
            # Reset counters for levels deeper than the current one
            header_stack = header_stack[0...index + 1]
            header_stack[index] = header_stack[index] + 1 # Increment the counter for the new level

          elsif new_level == last_level
            header_stack[index] = header_stack[index] + 1 # Increment the counter for the current level

          elsif new_level > last_level
            # Fill gaps (e.g., h2 -> h4) with 1s
            header_stack += Array.new(new_level - last_level, 1) # All new levels start at 1
          end

          # Generate the numbered header
          number = header_stack.join('.')

          #puts "[DEBUG] new_level: #{new_level}, last_level: #{last_level}, stack: #{header_stack}, number: #{number}, text: #{header_text}"

          # Update last_level
          last_level = new_level

          "#{'#' * last_level} #{number} #{header_text}"
        else
          line
        end
      end
    end

  end
end
