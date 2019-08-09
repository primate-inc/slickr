# MultiContraint class
class MultiContraint
  def initialize(constraints = [])
    @constraints = constraints
  end

  def matches?(request)
    matches = true
    @constraints.each do |constraint|
      matches &&= constraint.matches?(request)
    end
    matches
  end
end

# SlickrNavRouteHelper module
module SlickrNavRouteHelper
  def self.matches?(request)
    request = request.path

    path_info = Slickr::NavigationBuilder.new.nav_helper[:pathnames]
    routes = path_info.map { |path| path[:path] }
    request.in?(routes)
  end
end

Rails.application.routes.draw do
  %w[404 500].each do |code|
    get code, to: 'errors#show', code: code
  end
  get '/slickr_media_upload',
      to: 'slickr_media_uploads#index',
      as: :slickr_media_upload_file_download
  constraints(MultiContraint.new([SlickrNavRouteHelper])) do
    get '*slug' => 'pages#show', as: 'show_page'
  end

  root 'pages#show', slug: :home
end
