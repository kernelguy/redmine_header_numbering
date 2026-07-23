#require 'redmine'
require_relative File.expand_path('../lib/redmine_header_numbering', __FILE__)

Redmine::Plugin.register :redmine_header_numbering do
  name 'Automatic Header Numbering Plugin'
  author 'Steffen Brummer'
  description 'Adds optional numbering to headers in Redmine markdown'
  version '0.1.1'
  url 'https://github.com/kernelguy/redmine_header_numbering'
  requires_redmine :version_or_higher => '6.0.0'
end
