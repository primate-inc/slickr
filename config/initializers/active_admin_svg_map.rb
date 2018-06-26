module ActiveAdmin
  module Views
    module Pages
      module SvgMapBuilder
        def build(*args)
          super(*args)
          build_svg_map
        end

        def build_svg_map
          within body do
            render 'layouts/partials/svg-map'
          end
        end
      end

      Base.prepend(SvgMapBuilder)
    end
  end
end
