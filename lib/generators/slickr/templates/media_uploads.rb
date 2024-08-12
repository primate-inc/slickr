ActiveAdmin.register Slickr::MediaUpload do
  collection_action :all_pdfs, method: :get do
    pdf_files = Slickr::MediaUpload.pdf_files
    render json: {
      pdf_files: pdf_files,
      pdf_path: Rails.application.routes.url_helpers
                     .return_pdf_path_admin_slickr_media_uploads_path
    }.to_json
  end

  collection_action :return_pdf_path, method: :get do
    pdf = Slickr::MediaUpload.find(params[:id])
    path = pdf.file_url(:original)
    redirect_to path
  end
end
