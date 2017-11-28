if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Image do
    menu priority: 2, label: 'Images'

    actions :all, :except => [:new, :show]
    config.filters = false

    permit_params :attachment, :crop_data, data: {}

    index title: 'Image library', download_links: false do
      render 'gallery'
    end

    form :partial => "form"

    batch_action :destroy do |selection|
      Slickr::Image.find(selection).each do |image|
        image.destroy
      end
      render :json => Slickr::Image.all.map { |image| JSON.parse(image.to_json(
        methods: [:build_for_gallery, :admin_edit_path, :admin_update_path, :admin_batch_delete_path]
      ))}
    end

    controller do
      def index
        if params[:type] == 'page_edit'
          index! do |format|
            format.html { render :json => @images.to_json(
              methods: [:build_for_gallery]
            )}
          end
        else
          index!
        end
      end

      def create
        create! do |format|
          format.html { redirect_to admin_images_path }
          format.json { render :json => @image.to_json(
            methods: [:build_for_gallery, :admin_edit_path, :admin_update_path, :admin_batch_delete_path]
          )}
        end
      end

      def update
        @image = Slickr::Image.find(params[:image][:id])
        @image.crop(params[:image][:crop_data][:x],params[:image][:crop_data][:y],params[:image][:crop_data][:width],params[:image][:crop_data][:height])

        update! do |format|
          format.html { redirect_to edit_admin_image_path(resource) }
          format.json { render json: @image.to_json(methods: [:admin_update_path, :timestamped_image_url]) }
        end
      end
    end
  end
end
