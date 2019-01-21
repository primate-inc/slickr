include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Schedule do
    actions :index

    menu priority: 4

    filter :schedulable_type,
           as: :select,
           collection: proc {
             ::Slickr::ScheduleDecorator.decorate(
               ::Slickr::Schedule.select('DISTINCT(schedulable_type)')
             ).as_select
           }
    filter :publish_schedule_time

    index do
      column 'Scheduled date and time' do |schedule|
        schedule.publish_schedule_time.strftime('%d %B %Y (%H:%M)')
      end
      column 'Type' do |schedule|
        schedule.schedulable_type.constantize.model_name.human
      end
      column 'View' do |schedule|
        class_underscore = schedule.schedulable_type.constantize.table_name
        link_to 'View',
                controller: class_underscore.pluralize,
                action: 'edit',
                id: schedule.schedulable_id
      end
    end
  end
end
