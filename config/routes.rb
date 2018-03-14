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

module SlickrPageRouteHelper
  def self.matches?(request)
    request = request.path
    slug_sections = request.split('/').reject(&:empty?)
    matching_page = Slickr::Page.where(aasm_state: :published, slug: slug_sections.last)[0]
    return false if matching_page.nil?
    tree_sections = matching_page.self_and_ancestors.pluck(:slug).reverse - [matching_page.root.slug]
    return slug_sections == tree_sections
  end
end

Rails.application.routes.draw do
  constraints(MultiContraint.new([SlickrPageRouteHelper])) do
    get '*slug' => "pages#show", as: "show_page"
  end

  root "pages#show", slug: :home
end
