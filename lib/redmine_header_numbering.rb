module RedmineHeaderNumbering
  module WikiFormattingPatch
    def to_html(format, text, options = {})
      obj = options[:object]

      # Check if macro is in text
      has_macro = false
      if (text.present?) # During preview, obj is always nil
        has_macro = text.match?(/\{\{number_headers(?:\(\d+\))?\}\}/)
      end

      if has_macro
        Rails.logger.info { "[DEBUG] WikiFormattingPatch: Header numbering activated for #{obj.class if obj}!" } if defined?(Rails)
        Rails.logger.info { "[DEBUG] to_html(): text: #{text}" } if defined?(Rails)
        text = RedmineHeaderNumbering::TextProcessor.process_headers(text)
      end

      super(format, text, options)
    end
  end
end

# Prepend patch to class method
Redmine::WikiFormatting.singleton_class.prepend(RedmineHeaderNumbering::WikiFormattingPatch)
