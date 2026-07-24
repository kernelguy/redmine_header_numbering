require_relative '../lib/redmine_header_numbering/text_processor'
require 'benchmark'

fixture_path = File.expand_path('fixtures/example.md', __dir__)

unless File.exist?(fixture_path)
  puts "Error: Could not find Markdown file for benchmark test:: #{fixture_path}"
  exit 1
end

wiki_text = File.read(fixture_path)

# Multiply the text to simulate a large Wiki page
large_wiki_text = wiki_text * 100  # 100 copies of the sample text

# Benchmark the process_headers method
require 'benchmark'

Benchmark.bm do |x|
  x.report("Sample output") do
    2.times do
      puts RedmineHeaderNumbering::TextProcessor::process_headers(wiki_text.dup)
    end
  end

  x.report("1000x heavy load") do
    1000.times do
      RedmineHeaderNumbering::TextProcessor::process_headers(large_wiki_text.dup)
    end
  end
end
