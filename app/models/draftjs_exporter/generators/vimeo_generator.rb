require "erb"

class DraftjsExporter::Generators::VimeoGenerator
  def initialize contents
    slickr = Bundler.rubygems.find_name('slickr_cms').first.full_gem_path
    @contents = contents
    @template = File.read "#{slickr}/app/views/vimeo/iframe.html.erb"
  end

  def render
    ERB.new(@template).result(binding)
  end
end
