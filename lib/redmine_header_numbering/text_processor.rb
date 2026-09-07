module RedmineHeaderNumbering
  class TextProcessor

    MACRO_REGEX = /\{\{number_headers\((\d+)\)\}\}/

    def self.process_headers(text)
      header_stack = []
      last_level = 1
      # Maps the ORIGINAL Redmine anchor ID to the new NUMBERED anchor ID and label
      header_map = {}
      max_depth = 0
      anchor_counts = Hash.new(0)

      # 1. Process and number the headers
      text.gsub!(/^(?:(#+ [^\r\n]+)|({{number_headers\(?\d?\)?}}))(?=\r?$)/) do |matched|
        Rails.logger.debug { "[DEBUG] Header matched: #{matched.inspect}" } if defined?(Rails)

        if matched.start_with?('{{number_headers')
          if matched =~ MACRO_REGEX
            max_depth = $1.to_i
          end
          Rails.logger.debug { "[DEBUG] TOC depth set to: #{max_depth}" } if defined?(Rails)
          "|||NUMBER_HEADERS_TOC|||"
        else
          hashes, remainder = matched.split(' ', 2)
          new_level = hashes.length
          header_text = remainder.to_s.strip
          # Generate Redmine's native anchor ID for the original unnumbered header
          base_anchor = TextProcessor.format_reference(header_text)

          # Test if anchor has occurred before, if so, add an incremental number...
          count = anchor_counts[base_anchor]
          orig_anchor = count > 0 ? "#{base_anchor}_#{count}" : base_anchor
          anchor_counts[base_anchor] += 1

          # Skip level 1 headings, reserved for title
          if new_level <= 1
            header_map[orig_anchor] = { number: '', anchor: orig_anchor, orig_text: header_text, level: new_level }
            "#{'#' * new_level} #{header_text}"
          else
            # Prepend numbers or all sub level headings.
            index = new_level - 2

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

            # Generate Redmine's native anchor ID for the new numbered header
            new_anchor  = TextProcessor.format_reference("#{number} #{header_text}")

            # Store both the text prefix and the new anchor for the link processor
            header_map[orig_anchor] = { number: number, anchor: new_anchor, orig_text: header_text, level: new_level }

            "#{'#' * last_level} #{number} #{header_text}"
          end
        end
      end

      # 2. Find and correct all markdown internal links [](#anchor)
      text.gsub!(/\[([^\]]+)\]\(#([a-zA-Z0-9\-_]+)\)/) do |matched|
        Rails.logger.debug { "[DEBUG] Link matched: #{matched.inspect}, $1: #{$1}, $2: #{$2}" } if defined?(Rails)
        link_text = $1
        anchor_id = $2

        if header_map.key?(anchor_id)
          info = header_map[anchor_id]
          # If the link text matches the old header title, prepend the number to the visible text too
          if link_text == info[:orig_text]
            updated_text = "#{info[:number]} #{link_text}"
          elsif link_text == '#'
            updated_text = "[#{info[:number]}]"
          else
            updated_text = link_text
          end
          "[#{updated_text}](##{info[:anchor]})"
        else
          matched # Leave the link untouched if it doesn't match a numbered header
        end
      end

      # 3. Build the TOC from the detected headers
      toc_markdown = ""
      if max_depth > 0 && header_map.any?
        toc_markdown << "**Table of contents**\n\n"
        last_level = 0
        header_map.each_value do |entry|
          Rails.logger.debug { "[DEBUG] TOC entry: #{entry.inspect}" } if defined?(Rails)
          current_level = entry[:level].to_i
          if current_level <= max_depth
            if current_level > (last_level + 1)
              error_indent = "  " * (last_level + 1)
              toc_markdown << "#{error_indent}* **!!! MISSING HEADER LEVEL #{last_level+1} !!!**  \n"
            end
            indent = "  " * (current_level - 1) # -1 because level 1 is reserved for title
            anchor_text = "#{entry[:number]} #{entry[:orig_text]}".strip
            toc_markdown << "#{indent}* [#{anchor_text}](##{entry[:anchor]})  \n"
          end
          last_level = current_level
        end
        toc_markdown << "\n"
      end

      # Replace the macro with the TOC
      text.gsub!('|||NUMBER_HEADERS_TOC|||', toc_markdown)

      text
    end

    # Simulates Redmine's Markdown anchor generation (hyphens, no special chars)
    def self.format_reference(text)
      text.gsub('&', 'amp')             # Replace & with amp first
          .gsub(/[^a-zA-Z0-9\-_ ]/, '') # Remove special characters (^ = negated regex)
          .strip                        # Strip all whitespace from both ends
          .gsub(/\s+/, '-')             # Replace remaining whitespace blocks with single hyphens
    end
  end
end
