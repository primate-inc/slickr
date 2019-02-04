# frozen_string_literal: true

# Slickr Pages Controller
class PagesController < ApplicationController
  def show
    slug =  params[:slug].class == Symbol ? params[:slug] : params[:slug].split('/').last
    @slickr_page = Slickr::Page.left_outer_joins(:schedule)
                               .select('*', :id, 'slickr_schedules.id AS schedule_id')
                               .find_by(
                                 'slug = ? AND slickr_schedules.id IS NULL',
                                 slug
                               )
    insert_slickr_meta_tags(@slickr_page)
    raise AbstractController::ActionNotFound.new unless @slickr_page
    render layout: false
  end
end
