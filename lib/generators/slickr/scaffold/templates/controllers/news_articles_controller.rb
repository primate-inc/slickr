# frozen_string_literal: true

# Scaffold News Articles Controller
class NewsArticlesController < ApplicationController
  protect_from_forgery except: :index
  before_action :assign_meta_data, only: %i[index]

  def index
    @filters = initialize_filterrific(NewsArticle, filter_params) || return
    @news = @filters.find.is_published.order(date: :desc).page(params[:page])

    respond_to do |format|
      format.html do
        render :index,
               layout: '../slickr_page_templates/news',
               locals: { articles: @news }
      end
      # format.json { render json: @news.to_json }
      format.js { render :index, layout: false }
    end
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def show
    @news_article = NewsArticle.is_published.friendly.find(params[:id])
    insert_slickr_meta_tags(@news_article)
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

  def generate_meta_data(item, title)
    {
      meta_description: item.meta_description,
      og_title: title,
      og_description: item.meta_description,
      twitter_description: item.meta_description,
      og_url: request.original_url,
      twitter_title: title
    }
  end
end
