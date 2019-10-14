# frozen_string_literal: true

# Scaffold Events Controller
class EventsController < ApplicationController
  protect_from_forgery except: :index
  before_action :assign_meta_data, only: %i[index]

  def index
    @filters = initialize_filterrific(Event, filter_params) || return
    @events = @filters.find.is_published.order(start_time: :desc)
                      .page(params[:page])

    respond_to do |format|
      format.html do
        render :index,
               layout: '../slickr_page_templates/events',
               locals: { articles: @events }
      end
      # format.json { render json: @events.to_json }
      format.js { render :index, layout: false }
    end
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def show
    @event = Event.is_published.friendly.find(params[:id])
    insert_slickr_meta_tags(@event)
  end

  private

  def filter_params
    params[:filterrific].present? ? params[:filterrific] : { has_category: [] }
  end

  def assign_meta_data
    @page = Slickr::Page.find_by(layout: params[:controller]) ||
            Slickr::Page.new
    @slickr_page_title = @page['title']
    @slickr_meta_override = generate_meta_data(@page, @slickr_page_title)
  end

  def generate_meta_data(page, title)
    meta_data = page.meta_tag || Slickr::MetaTag.new
    {
      meta_description: meta_data.meta_description,
      og_title: meta_data.og_title.present? ? meta_data.og_title : title,
      og_description: meta_data.og_description.present? ? meta_data.twitter_description : meta_data.meta_description,
      og_image: page.og_image.present? ? (request.protocol + request.host_with_port + page.og_image.image_url(:s_limit)) : page.header_image.present? ? (request.protocol + request.host_with_port + page.header_image.image_url(:s_limit)) : '',
      twitter_description: meta_data.twitter_description.present? ? meta_data.twitter_description : meta_data.meta_description,
      og_url: request.original_url,
      twitter_title: meta_data.twitter_title.present? ? meta_data.twitter_title : title,
      twitter_image: page.twitter_image.present? ? (request.protocol + request.host_with_port + page.twitter_image.image_url(:s_limit)) : page.header_image.present? ? (request.protocol + request.host_with_port + page.header_image.image_url(:s_limit)) : ''
    }
  end
end
