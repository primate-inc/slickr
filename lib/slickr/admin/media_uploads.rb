if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::MediaUpload do
    MEDIA_PER_PAGE ||= 25
    menu priority: 2, label: 'Media'
    actions :all, :except => [:new, :show]

    config.filters = false
    config.per_page = MEDIA_PER_PAGE

    permit_params :image, :file, additional_info: {}

    breadcrumb do
      if params[:action] == 'index'
        [ link_to('Admin', admin_root_path) ]
      else
        [
          link_to('Admin', admin_root_path),
          link_to('Media', admin_slickr_media_uploads_path)
        ]
      end
    end

    index title: 'Media', download_links: false do
      render 'gallery'
    end

    form partial: 'form'

    batch_action :destroy do |selection|
      Slickr::MediaUpload.find(selection).each(&:destroy)
      remaining_media = Slickr::MediaUpload.all.map do |media|
        JSON.parse(
          media.to_json(methods: %i[build_for_gallery admin_edit_path
                                   admin_update_path admin_batch_delete_path])
        )
      end
      render json: remaining_media
    end

    collection_action :return_media_path, method: :get do
      media = Slickr::MediaUpload.find(params[:id])
      path = media.image_url(:m_limit)
      mime_type = media.image_data['original']['metadata']['mime_type']

      if path.starts_with?('/')
        file = File.join(Rails.root, 'public', path)
        send_file file, type: mime_type, disposition: 'inline'
      else
        data = open(url, media.open_uri_options) { |f| f.read }
        send_data data, type: mime_type, disposition: 'inline'
      end
    end

    controller do
      def index
        if params[:type] == 'page_edit'
          total = Slickr::MediaUpload.all.count
          @slickr_media_uploads = Slickr::MediaUpload
                                  .order(created_at: :desc)
                                  .limit(MEDIA_PER_PAGE)
                                  .offset(
                                    (params[:page].to_i - 1) * MEDIA_PER_PAGE
                                  )

          respond_to do |format|
            format.html do
              render json: {
                images: JSON.parse(
                  @slickr_media_uploads.to_json(methods: [:build_for_gallery])
                ),
                pagination_info: {
                  current_page: params[:page].to_i,
                  total_pages: ((total / MEDIA_PER_PAGE).floor + 1),
                  images_per_page: MEDIA_PER_PAGE
                },
                loading: true
              }.to_json
            end
          end
        else
          index!
        end
      end

      def create
        create! do |format|
          format.html { redirect_to admin_slickr_images_path }
          format.json do
            if @slickr_media_upload.image.try(:keys).try(:count) == 1 ||
               @slickr_media_upload.file.try(:keys).try(:count) == 1
              # when image processing has failed
              json_return = @slickr_media_upload.to_json(
                methods: %i[
                  build_for_gallery admin_edit_path admin_update_path
                  admin_batch_delete_path
                ]
              )
              # delete the image, return an error and create the response body
              #  but the build_for_gallery will return and hash with empty
              #  values
              @slickr_media_upload.destroy
              self.status = 400
              self.response_body = json_return
            else
              render json: @slickr_media_upload.to_json(
                methods: %i[
                  build_for_gallery admin_edit_path admin_update_path
                  admin_batch_delete_path
                ]
              )
            end
          end
        end
      end

      def update
        @slickr_media_upload = Slickr::MediaUpload.find(
          params[:slickr_media_upload][:id]
        )
        @slickr_media_upload.crop(
          params[:slickr_media_upload][:crop_data][:x],
          params[:slickr_media_upload][:crop_data][:y],
          params[:slickr_media_upload][:crop_data][:width],
          params[:slickr_media_upload][:crop_data][:height]
        )
        update! do |format|
          format.html { redirect_to admin_edit_path }
          format.json do
            render json: @slickr_media_upload.to_json(
              methods: %i[admin_update_path timestamped_image_url]
            )
          end
        end
      end
    end
  end
end
