Redmine::Plugin.register :redmine_header_numbering do
  name 'Wiki Header Numbering Plugin'
  author 'Steffen Brummer'
  description 'Adds optional numbering to headers in Redmine Wiki pages'
  version '0.0.1'
  url 'https://github.com/kernelguy/redmine_header_numbering'

  # Register the macro and hook
  require_dependency 'redmine_header_numbering'
end

