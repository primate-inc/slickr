require "erb"

class DraftjsExporter::Generators::YouTubeGenerator
  def initialize contents
    slickr = Bundler.rubygems.find_name('slickr_cms').first.full_gem_path
    @contents = contents
    @template = File.read "#{slickr}/app/views/you_tube/iframe.html.erb"
  end

  def render
    ERB.new(@template).result(binding)
  end
end
