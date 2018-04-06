# Handles pages errors and defaults to 500 if none defined
class ErrorsController < ApplicationController
  def show
    render "#{status_code.to_s}_error", status: status_code
  end

  private

  def status_code
    params[:code] || 500
  end
end
