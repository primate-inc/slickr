# frozen_string_literal: true

# Slickr Pages Controller
class PagesController < ApplicationController
  def show
    slug =  params[:slug].class == Symbol ? params[:slug] : params[:slug].split('/').last
    @slickr_page = Slickr::Page.where(slug: slug, aasm_state: :published).first
    @slickr_meta_additional = { page_title: @slickr_page.page_title }
    raise AbstractController::ActionNotFound.new unless @slickr_page
    render layout: false
  end
end
