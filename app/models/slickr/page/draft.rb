module Slickr
  class Page::Draft < Slickr::Page
    belongs_to :slickr_page, class_name: "Slickr::Page"

    skip_callback :create, :after, :create_draft
    skip_callback :create, :after, :activate_draft

    def activate
      slickr_page.update_attribute(:active_draft_id, self.id)
    end

  end
end
