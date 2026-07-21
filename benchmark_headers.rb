# Load the hook listener
require_relative 'lib/redmine_header_numbering/text_processor'
require 'benchmark'

# Sample Wiki text with headers and the macro
wiki_text = <<~WIKI
  # Title

  ## Header 1
  ## Header 2
  ### Subheader 2.1
  ### Subheader 2.2
  ## Header 3
  ### Subheader 3.1
  #### Sub-subheader 3.1.1
WIKI

# Multiply the text to simulate a large Wiki page
large_wiki_text = wiki_text * 100  # 100 copies of the sample text

# Benchmark the process_headers method
require 'benchmark'

Benchmark.bm do |x|
  x.report("Sample output") do
    2.times do
      puts RedmineHeaderNumbering::TextProcessor::process_headers(wiki_text)
    end
  end

  x.report("1000x heavy load") do
    1000.times do
      RedmineHeaderNumbering::TextProcessor::process_headers(large_wiki_text)
    end
  end
end
