# MultiContraint class
class MultiContraint
  def initialize(constraints = [])
    @constraints = constraints
  end

  def matches?(request)
    # matches = true
    # @constraints.each do |constraint|
    #   matches &&= constraint.matches?(request)
    # end
    # matches

    # temp until all sites moved onto new nav
    count = 0
    @constraints.each do |constraint|
      count += 1 if constraint.matches?(request)
    end
    true if count > 0
  end
end

module SlickrPageRouteHelper
  def self.matches?(request)
    request = request.path
    slug_sections = request.split('/').reject(&:empty?)
    matching_page = Slickr::Page.where(
      aasm_state: :published, slug: slug_sections.last
    )[0]
    return false if matching_page.nil?
    tree_sections = matching_page.root? ? [matching_page.slug] : matching_page.self_and_ancestors.pluck(:slug).reverse - [matching_page.root.slug]
    return slug_sections == tree_sections
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
  constraints(MultiContraint.new([SlickrPageRouteHelper, SlickrNavRouteHelper])) do
    get '*slug' => 'pages#show', as: 'show_page'
  end

  root 'pages#show', slug: :home
end
