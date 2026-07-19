Redmine::WikiFormatting::Macros.register do
  desc "Enable header numbering for this Wiki page."
  macro :number_headers do |obj, args, text|
    RedmineHeaderNumbering::Macro::NumberHeaders.new(obj, args, text).execute
  end
end

