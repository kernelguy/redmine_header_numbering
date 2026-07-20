# Load the Redmine environment
require_relative './../redmine/config/environment'

# Load the hook listener
require_relative 'lib/redmine_header_numbering/hook_listener'

# Include the module to access process_headers
include RedmineHeaderNumbering

# Sample Wiki text with headers and the macro
wiki_text = <<~WIKI
  {{number_headers}}

  # Title

  ## Header 1
  ### Subheader 1.1
  ### Subheader 1.2
  ## Header 2
  ### Subheader 2.1
  #### Sub-subheader 2.1.1
WIKI

# Multiply the text to simulate a large Wiki page
large_wiki_text = wiki_text * 100  # 100 copies of the sample text

# Benchmark the process_headers method
require 'benchmark'

Benchmark.bm do |x|
  x.report("process_headers:") do
    1000.times { HookListener::process_headers(large_wiki_text) }
  end
end
