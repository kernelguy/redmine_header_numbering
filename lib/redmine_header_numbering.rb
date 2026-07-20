require_relative 'redmine_header_numbering/text_processor'
require_relative 'redmine_header_numbering/macro/number_headers'

module RedmineHeaderNumbering
  module WikiFormattingPatch
    def to_html(format, text, options = {})
      Rails.logger.info "[DEBUG] WikiFormattingPatch::to_html is called!"

      Rails.logger.debug "[DEBUG] Wiki info: format: #{format}, text: #{text}, options: #{options}"

      # 1. Tjek om teksten er til stede og indeholder din makro
      if text.present? && text.include?('{{number_headers}}')
        Rails.logger.info "[DEBUG] Nummerering udløst for tekststykke!"

        # Generer den nye tekst med sektionsnumre via din processor
        text = RedmineHeaderNumbering::TextProcessor.process_headers(text)
      end

      # 2. VIGTIGT FOR RAILS 8: Vi skal sende (format, text, options) eksplicit med i super.
      # Hvis vi bare skriver 'super', bruger Ruby de helt oprindelige, umodificerede argumenter.
      super(format, text, options)
    end
  end
end

# Da patchen beviseligt kører med det samme, danner vi præpenderingen direkte her
# uden at pakke det ind i utilregnelige callbacks:
Redmine::WikiFormatting.singleton_class.prepend(RedmineHeaderNumbering::WikiFormattingPatch)

# Registrering af makroen (så den ikke kaster fejl i editoren)
Redmine::WikiFormatting::Macros.register do
  desc "Enable header numbering for this Wiki page."
  macro :number_headers do |obj, args, text|
    nil
  end
end
