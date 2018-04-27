module Slickr
  class NavigationBuilder
    def initialize; end

    def nav_helper
      nav_trees = Slickr::Navigation.all_nav_trees
      pathnames = all_pages_pathnames(nav_trees)
      {
        pathnames: pathnames,
        nav_menus: all_nav_menus(nav_trees, pathnames)
      }
    end

    # example result
    # [{:page_id=>1, :path=>"/level1"}, {:page_id=>2, :path=>"/level1/level2"}]
    def all_pages_pathnames(nav_trees)
      main_page_paths = build_main_page_paths(nav_trees)
      additonal_page_paths = build_additonal_page_paths(
        nav_trees, main_page_paths
      )
      main_page_paths + additonal_page_paths
    end

    def all_nav_menus(nav_trees, pathnames)
      menu_hash = {}
      nav_trees.map do |root|
        menu_hash[root['title']] = root['children'].map do |child_hash|
          if root['root_type'] == 'Page'
            parent_link = pathnames.select do |path|
              path[:page_id] == root['page_id']
            end[0][:path]
          else
            parent_link = '/'
          end
          build_nav(child_hash, pathnames, {}, parent_link)
        end
      end
      menu_hash
    end

    def build_nav(child_hash, pathnames, hash, parent_link)
      if child_hash['child_type'] == 'Page'
        parent_link = pathnames.select do |path|
          path[:page_id] == child_hash['page_id']
        end[0][:path]
      else
        parent_link = parent_link
      end
      menu_hash = case child_hash['child_type']
      when 'Page'
        build_page_nav(child_hash, pathnames)
      when 'Header'
        build_header_nav(child_hash, pathnames)
      when 'Custom Link'
        build_custom_link_nav(child_hash, pathnames)
      when 'Anchor'
        build_anchor_link_nav(child_hash, pathnames, parent_link)
      end
      menu_hash['children'] = child_hash['children'].map do |child_hash|
        build_nav(child_hash, pathnames, menu_hash, parent_link)
      end
      menu_hash
    end

    def build_page_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'] ? hash['image'] : hash['page_header_image'],
        text: {
          text: hash['text'], page_header: hash['page_header'],
          page_into: hash['page_into']
        },
        link: pathnames.select do |path|
          path[:page_id] == hash['page_id']
        end[0][:path],
        link_text: hash['link_text'] ? hash['link_tex'] : hash['title']
      }
    end

    def build_header_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text']
      }
    end

    def build_custom_link_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text'],
        link: hash['link'],
        link_text: hash['link_text']
      }
    end

    def build_anchor_link_nav(hash, pathnames, parent_link)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text'],
        link: parent_link + hash['link'],
        link_text: hash['link_text']
      }
    end

    def all_nav_trees
      first.build_tree_structure[0]['children']
    end

    # build up all of the pathnames nested under a root_type of 'Root'
    # example result
    # [{:page_id=>1, :path=>"/level1"}, {:page_id=>2, :path=>"/level1/level2"}]
    def build_main_page_paths(nav_trees)
      navs = nav_trees.map { |root| root if root['root_type'] == 'Root' }
      navs.compact.map do |hash|
        iterate_children_for_pathnames(hash, '/')
      end.flatten
    end

    # build up all of the pathnames nested under a root_type of 'Page'
    # the pathnames and associated page id is also passed in to allow these
    # pathnames to build upon the main pathnames
    # example result
    # [{:page_id=>3, :path=>"/level1/level2/level3"}]
    def build_additonal_page_paths(
      nav_trees, main_page_paths
    )
      navs = nav_trees.map { |root| root if root['root_type'] == 'Page' }
      navs.compact.map do |hash|
        start_path_name = main_page_paths.select do |path|
          path[:page_id] == hash['page_id']
        end
        iterate_children_for_pathnames(hash, "#{start_path_name[0][:path]}/")
      end.flatten
    end

    # will iterate the children of the hash passed in.
    def iterate_children_for_pathnames(hash, pathname)
      hash['children'].map do |child_hash|
        build_page_pathnames(child_hash, pathname, [])
      end
    end

    # Keeps iterating through the deeply nested hash in order to generate an
    # array of hashed with keys of page_id and path
    def build_page_pathnames(hash, pathname, array)
      if hash['child_type'] == 'Page'
        new_pathname = pathname + hash['slug']
        array.push(page_id: hash['page_id'], path: new_pathname)
        hash['children'].map do |child_hash|
          build_page_pathnames(child_hash, "#{new_pathname}/", array)
        end
      end
      if hash['child_type'] == 'Header'
        hash['children'].map do |child_hash|
          build_page_pathnames(child_hash, pathname, array)
        end
      end
      array
    end
  end
end
