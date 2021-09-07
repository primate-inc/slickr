# frozen_string_literal: true

# Slickr Pages Controller
class PagesController < ApplicationController
  include SlickrPagesHelper

  def show
    if params[:slug].class == Symbol
      @slickr_page = Slickr::Page.left_outer_joins(:schedule)
                                 .select('*', :id, 'slickr_schedules.id AS schedule_id')
                                 .find_by(
                                   'slug = ? AND slickr_schedules.id IS NULL',
                                   params[:slug]
                                 )
    else
      slug_array = params[:slug].split('/')
      slug_tests = slug_array.each_with_index.map do |s, i|
        Slickr::Page.left_outer_joins(:schedule)
                    .select('*', :id, 'slickr_schedules.id AS schedule_id')
                    .find_by(
                      'slug = ? AND slickr_schedules.id IS NULL',
                      slug_array.last(i + 1).join("/")
                    )
      end
      @slickr_page = slug_tests.delete_if(&:blank?).first
    end
    raise AbstractController::ActionNotFound.new unless @slickr_page
    insert_slickr_meta_tags(@slickr_page)
    render slickr_page_render_options
  end
end
