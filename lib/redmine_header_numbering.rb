#require 'redmine'
#require_relative 'redmine_header_numbering/text_processor'

module RedmineHeaderNumbering
  module WikiFormattingPatch
    def to_html(format, text, options = {})
      obj = options[:object]

      # TODO: The text argument is the only updated text during preview, but macros are exchanged with macro(\d+).
      # So inserting or deleting a {{number_headers}} macro will not take effect until after save.

      # Check if macro is in text
      has_macro = false
      if (text.present?) # During preview, obj is always nil
        has_macro = text.include?('{{number_headers}}')
      end

      if not has_macro
        if obj.respond_to?(:text) # WikiContent
          Rails.logger.info "[DEBUG] to_html(): obj.text: #{obj.text}"
          has_macro = obj.text.to_s.include?('{{number_headers}}')
        elsif obj.respond_to?(:description) # Issue / Task description
          Rails.logger.info "[DEBUG] to_html(): obj.description: #{obj.description}"
          has_macro = obj.description.to_s.include?('{{number_headers}}')
        elsif obj.respond_to?(:notes) # Journal / Notes comments
          Rails.logger.info "[DEBUG] to_html(): obj.notes: #{obj.notes}"
          has_macro = obj.notes.to_s.include?('{{number_headers}}')
        end
      end

      if has_macro
        Rails.logger.info "[DEBUG] WikiFormattingPatch: Header numbering activated for #{obj.class if obj}!"
        Rails.logger.info "[DEBUG] to_html(): text: #{text}"
        text = RedmineHeaderNumbering::TextProcessor.process_headers(text)
      end

      super(format, text, options)
    end
  end
end

# Prepend patch to class method
Redmine::WikiFormatting.singleton_class.prepend(RedmineHeaderNumbering::WikiFormattingPatch)

# Register macro, to just return an empty string and not fail
# Redmine::WikiFormatting::Macros.register do
#   desc "Enable header numbering for this page/issue/comment."
#   macro :number_headers do |obj, args, text|
#     Rails.logger.info "[DEBUG] number_headers macro activated!"
#     "".html_safe
#   end
# end
