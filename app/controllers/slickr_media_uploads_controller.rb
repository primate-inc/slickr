# frozen_string_literal: true

# SlickrMediaUploadsController controller
class SlickrMediaUploadsController < ApplicationController
  def index
    @file = Slickr::MediaUpload.find(params[:id])
    show unless @file.image
  end

  def show
    path = @file.file_url
    redirect_to path
  end
end
