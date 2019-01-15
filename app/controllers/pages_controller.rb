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
    @slickr_page_title = @slickr_page.page_title
    og_title = @slickr_page.og_title.present? ? @slickr_page.og_title : @slickr_page.page_title
    og_description = @slickr_page.og_description.present? ? @slickr_page.og_description : @slickr_page.meta_description
    @slickr_meta_override = {
                              meta_description: @slickr_page.meta_description,
                              og_title: og_title,
                              og_description: og_description,
                              og_url: request.original_url,
                              og_image: '',
                              twitter_title: (@slickr_page.twitter_title.present? ? @slickr_page.twitter_title : og_title),
                              twitter_description: (@slickr_page.twitter_description.present? ? @slickr_page.twitter_description : og_description),
                              twitter_image: ''
                            }
    raise AbstractController::ActionNotFound.new unless @slickr_page
    render layout: false
  end
end
