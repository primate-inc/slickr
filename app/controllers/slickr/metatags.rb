# frozen_string_literal: true

module Slickr
  # Metatags module
  module Metatags
    extend ActiveSupport::Concern

    def insert_slickr_meta_tags(inst_var)
      meta_tags = inst_var.meta_tag
      @slickr_page_title = meta_tags.try(:title_tag)
      @slickr_meta_override = {
        meta_description: meta_tags.try(:meta_description),
        og_title: meta_tags.try(:og_title),
        og_description: meta_tags.try(:og_description),
        og_image: inst_var.try(:og_image).try(:image_url, :l_limit, host: ActionController::Base.asset_host),
        og_url: request.original_url,
        twitter_title: meta_tags.try(:twitter_title),
        twitter_description: meta_tags.try(:twitter_description),
        twitter_image: inst_var.try(:twitter_image).try(:image_url, :l_limit, host: ActionController::Base.asset_host)
      }
    end
  end
end
