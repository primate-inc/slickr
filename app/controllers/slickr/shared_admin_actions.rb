module Slickr
  module SharedAdminActions
    extend ActiveSupport::Concern

    def self.included(base)
      ###############
      # Actions items
      ###############

      base.send(:action_item, :publish, only: :edit) do
        if resource.schedule
          class_underscore = resource.class.name.parameterize.underscore
          link = "publish_admin_#{class_underscore}_path"
          link_to send(link, resource), method: :put do
            '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                  xlink:href="#svg-publish"></use></svg>Publish'.html_safe
          end
        end
      end

      base.send(:action_item, :unpublish, only: :edit) do
        unless resource.schedule
          class_underscore = resource.class.name.parameterize.underscore
          link = "unpublish_admin_#{class_underscore}_path"
          link_to send(link, resource), method: :put do
            '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                  xlink:href="#svg-cross"></use></svg>Unpublish'.html_safe
          end
        end
      end

      ###############
      # Member actions
      ###############

      base.send(:member_action, :publish, method: :put) do
        if resource.valid?
          resource.schedule.update(
            publish_schedule_date: nil, publish_schedule_time: nil
          )
          Slickr::EventLog.create(
            action: :publish, eventable: resource,
            admin_user: current_admin_user
          )
        end
        respond_to do |format|
          format.html { redirect_to edit_resource_path, notice: 'Published' }
          format.json { render json: resource.as_json }
        end
      end

      base.send(:member_action, :unpublish, method: :put) do
        if resource.valid?
          Slickr::Schedule.create(
            schedulable: resource,
            publish_schedule_date: Date.today + 100.years,
            publish_schedule_time: Time.now + 100.years
          )
          Slickr::EventLog.create(
            action: :unpublish, eventable: resource,
            admin_user: current_admin_user
          )
        end
        respond_to do |format|
          format.html { redirect_to edit_resource_path, notice: 'Unpublished' }
          format.json { render json: resource.as_json }
        end
      end
    end
  end
end
