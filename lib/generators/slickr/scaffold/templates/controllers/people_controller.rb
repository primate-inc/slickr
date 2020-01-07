# frozen_string_literal: true

# Scaffold People Controller
class PeopleController < ApplicationController
  before_action :assign_meta_data, only: %i[index]

  def index
    @people = People.is_published.order(:slug)

    respond_to do |format|
      format.html do
        render :index,
               layout: '../slickr_page_templates/people',
               locals: { people: @people }
      end
    end
  end

  def show
    @person = People.is_published.friendly.find(params[:id])
    insert_slickr_meta_tags(@person)
  end

  private

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
