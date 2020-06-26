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


      base.send(:action_item, :publish, only: :edit, if: Proc.new {
        base.config.resource_class_name.classify.constantize.respond_to?(:slickr_schedulable)
      }) do
        if resource.schedule && authorized?(:publish, resource.class)
          table_single = resource.class.name.underscore.singularize.downcase.gsub("/","_")
          link = "publish_admin_#{table_single}_path"
          link_to send(link, resource), method: :put do
            '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                  xlink:href="#svg-publish"></use></svg>Publish'.html_safe
          end
        end
      end

      base.send(:action_item, :unpublish, only: :edit, if: Proc.new {
        base.config.resource_class_name.classify.constantize.respond_to?(:slickr_schedulable)
      }) do
        if authorized?(:publish, resource.class)
          unless resource.schedule
            table_single = resource.class.name.underscore.singularize.downcase.gsub("/","_")
            link = "unpublish_admin_#{table_single}_path"
            link_to send(link, resource), method: :put do
              '<svg class="svg-icon"><use xmlns:xlink="http://www.w3.org/1999/xlink"
                    xlink:href="#svg-cross"></use></svg>Unpublish'.html_safe
            end
          end
        end
      end

      base.send(:action_item, :"preview_#{base.config.resource_name.singular_route_key}", only: [:edit, :show], method: :get, if: Proc.new {
        base.config.resource_class_name.classify.constantize.respond_to?(:slickr_previewable_opts) &&
        base.config.resource_class_name.classify.constantize.slickr_previewable_opts &&
        base.config.resource_class_name.classify.constantize.slickr_previewable_opts[:preview_enabled]
      }) do
        link_to 'Preview', send("preview_#{base.config.resource_name.singular_route_key}_admin_#{base.config.resource_name.singular_route_key}_path"), target: '_blank'
      end


      ###############
      # Member actions
      ###############

      base.send(:member_action, :restore, method: :get) do
        if defined?(resource.undiscard)
          resource.undiscard
          resource.create_activity key: "#{base.config.resource_name.singular_route_key}.restore" if defined?(resource.create_activity)
        end
        redirect_to admin_rubbish_path(filter: base.config.resource_name.route_key)
      end

      base.send(:member_action, :discard, method: :get) do
        if defined?(resource.discard)
          resource.discard
          resource.create_activity key: "#{base.config.resource_name.singular_route_key}.remove" if defined?(resource.create_activity)
        end
        redirect_to collection_path
      end

      base.send(:member_action, :"preview_#{base.config.resource_name.singular_route_key}", method: :get) do
        resource.slickr_previewable_instance_variables.each { |name, value| instance_variable_set("@#{name}", value) }
        render layout: resource.slickr_previewable_layout, template: resource.slickr_previewable_template, locals: resource.slickr_previewable_locals
      end

      base.send(:member_action, :publish, method: :put) do
        if resource.valid?
          resource.schedule.update(
            publish_schedule_date: nil, publish_schedule_time: nil
          )
          resource.create_activity key: "#{base.config.resource_name.singular_route_key}.publish" if defined?(resource.create_activity)
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
          resource.create_activity key: "#{base.config.resource_name.singular_route_key}.unpublish" if defined?(resource.create_activity)
        end
        respond_to do |format|
          format.html { redirect_to edit_resource_path, notice: 'Unpublished' }
          format.json { render json: resource.as_json }
        end
      end
    end
  end
end
