ActiveAdmin.register Slickr::MediaUpload do
  collection_action :all_pdfs, method: :get do
    pdf_files = Slickr::MediaUpload.pdf_files
    render json: {
      pdf_files: pdf_files,
      pdf_path: Rails.application.routes.url_helpers
                     .slickr_media_upload_file_download_path
    }.to_json
  end

  collection_action :return_pdf_path, method: :get do
    pdf = Slickr::MediaUpload.find(params[:id])
    path = pdf.file_url
    redirect_to path
  end
end
