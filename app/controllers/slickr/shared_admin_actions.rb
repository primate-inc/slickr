# frozen_string_literal: true

module Slickr
  # SharedAdminActions module
  module SharedAdminActions
    extend ActiveSupport::Concern

    def self.included(base)

      ###############
      # Before actions
      ###############

      # If user has no publish permission then make sure any schedule stays as
      # it is. Also prevents schedule from being cleared because the form
      # fields are't available for unauthorised users for publishing and
      # therefore schedule info gets set as nil which destroys an
      # existing schedule.
      base.send(:before_action, only: :update) do
        unless authorized?(:publish, resource.class)
          return if resource.published?
          table_single = resource.class.table_name.singularize
          params.send(:[], table_single)[:schedule_attributes].merge!(
            publish_schedule_date: resource.schedule.publish_schedule_date,
            publish_schedule_time: resource.schedule.publish_schedule_time
          )
        end
      end

      ###############
      # Actions items
      ###############

      base.send(:action_item, :publish, only: :edit) do
        if resource.schedule && authorized?(:publish, resource.class)
          table_single = resource.class.table_name.singularize
          link = "publish_admin_#{table_single}_path"
          link_to send(link, resource), method: :put do
            '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                  xlink:href="#svg-publish"></use></svg>Publish'.html_safe
          end
        end
      end

      base.send(:action_item, :unpublish, only: :edit) do
        if authorized?(:publish, resource.class)
          unless resource.schedule
            table_single = resource.class.table_name.singularize
            link = "unpublish_admin_#{table_single}_path"
            link_to send(link, resource), method: :put do
              '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                    xlink:href="#svg-cross"></use></svg>Unpublish'.html_safe
            end
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
