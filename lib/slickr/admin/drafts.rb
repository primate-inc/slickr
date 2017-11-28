if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Page::Draft, as: 'Draft' do
    form do |f|
      f.inputs do
        f.input :content, as: :text
      end
      f.actions
    end
  end
end
