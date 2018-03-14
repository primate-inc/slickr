class PagesController < ApplicationController
  def show
    slug =  params[:slug].class == Symbol ? params[:slug] : params[:slug].split('/').last
    @slickr_page = Slickr::Page.where(slug: slug, aasm_state: :published).first
    if @slickr_page
      render layout: false
    else
      raise AbstractController::ActionNotFound.new
    end
  end
end
