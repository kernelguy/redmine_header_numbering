module RedmineHeaderNumbering
  module Macro
    class NumberHeaders < Redmine::WikiFormatting::Macros::Base
      def execute(macro_obj, params, body)
        # This macro does nothing visible; the hook handles the numbering
        ""
      end
    end
  end
end

