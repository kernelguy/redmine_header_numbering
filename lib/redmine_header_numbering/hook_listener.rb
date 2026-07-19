module RedmineHeaderNumbering
  class HookListener < Redmine::Hook::Listener
    # Fires before the Wiki page is rendered
    def controller_wiki_show_before_render(context = {})
      controller = context[:controller]
      @wiki_page = controller.instance_variable_get(:@page)
      @wiki_content = @wiki_page.content

      # Check if the macro {{number_headers}} is present in the content
      if @wiki_content.text.include?('{{number_headers}}')
        # Process the content to add numbering
        processed_content = process_headers(@wiki_content.text)

        # Replace the content with the processed version
        @wiki_page.content.text = processed_content
      end
    end

    private

    def process_headers(text)
      lines = text.split("\n")
      header_stack = [] # Track header levels (e.g., [1, 1, 2] for h1, h1, h2)
      number_headers = false # Flag to enable numbering

      lines.map do |line|
        if line.include?('{{number_headers}}')
          number_headers = true
          line.gsub('{{number_headers}}', '') # Remove the macro from output
        elsif line.start_with?('#') && number_headers
          # Extract header level and text
          level = line.match(/^#+/)[0].length
          header_text = line.sub(/^#+/, '').strip

          # Adjust the stack for the current level
          header_stack = header_stack[0...level - 1] if level <= header_stack.size
          header_stack << (header_stack.last || 0) + 1

          # Generate the numbered header
          number = header_stack.join('.')
          "#{'#' * level} #{number} #{header_text}"
        else
          line
        end
      end.join("\n")
    end
  end
end

