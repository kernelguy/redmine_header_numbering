require_relative 'redmine_header_numbering/hook_listener'
require_relative 'redmine_header_numbering/macro/number_headers'

# to_prepare is performed after everything is loaded in Redmine
Rails.configuration.to_prepare do
  # Register the hook listener
  Redmine::Hook::Listener.register(RedmineHeaderNumbering::HookListener)

  # Register the macro
  Redmine::WikiFormatting::Macros.register do
    desc "Enable header numbering for this Wiki page."
    macro :number_headers do |obj, args, text|
      RedmineHeaderNumbering::Macro::NumberHeaders.new(obj, args, text).execute
    end
  end
end
