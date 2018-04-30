# frozen_string_literal: true

module Slickr
  # NavigationBuilder class
  class NavigationBuilder
    # example result
    # {
    #   :pathnames=>
    #     [
    #       {:page_id=>1, :path=>"/level1"},
    #       {:page_id=>2, :path=>"/level1/level2"}
    #     ],
    #   :nav_menus=>
    #     {
    #       "Main navigation"=>
    #         [{
    #           :title=>"Menu", :image=>nil, :text=> {
    #             :text=>"some text", :page_header=>nil, :page_into=>nil
    #           }, :link=>"/menu", :link_text=>"Menu", "children"=>[]
    #         }]
    #     }
    # }
    def nav_helper
      nav_trees = Slickr::Navigation.all_nav_trees
      return if nav_trees.nil?
      pathnames = all_pages_pathnames(nav_trees)
      {
        pathnames: pathnames,
        nav_menus: all_nav_menus(nav_trees, pathnames)
      }
    end

    private

    #####################
    # Build pathnames
    #####################

    # example result
    # [{:page_id=>1, :path=>"/level1"}, {:page_id=>2, :path=>"/level1/level2"}]
    def all_pages_pathnames(nav_trees)
      main_page_paths = build_main_page_paths(nav_trees)
      additonal_page_paths = build_additonal_page_paths(
        nav_trees, main_page_paths
      )
      main_page_paths + additonal_page_paths
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
        start_path = path_finder(main_page_paths, hash)[:path]
        iterate_children_for_pathnames(hash, "#{start_path}/")
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
      elsif hash['child_type'] == 'Header'
        no_link = hash['link'].blank?
        new_pathname = no_link ? pathname : "#{pathname}#{hash['link']}/"
        hash['children'].map do |child_hash|
          build_page_pathnames(child_hash, new_pathname, array)
        end
      end
      array
    end

    #####################
    # Build nav menus
    #####################

    # example result
    # {
    #   "Main navigation"=>
    #     [{
    #       :title=>"Menu", :image=>nil, :text=> {
    #         :text=>"some text", :page_header=>nil, :page_into=>nil
    #       }, :link=>"/menu", :link_text=>"Menu", "children"=>[]
    #     }],
    #   "Header"=>
    #     [{
    #       :title=>"Menu", :image=>nil
    #     }]
    # }
    def all_nav_menus(nav_trees, pathnames)
      menu_hash = {}
      nav_trees.map do |root|
        menu_hash[root['title']] = root['children'].map do |child_hash|
          parent_link = if root['root_type'] == 'Page'
                          path_finder(pathnames, root)[:path]
                        else
                          '/'
                        end
          build_nav(child_hash, pathnames, parent_link)
        end
      end
      menu_hash
    end

    # Builds the hash for an individual nav menu.
    # example result
    # {
    #   :title=>"Menu", :image=>nil, :text=> {
    #     :text=>"some text", :page_header=>nil, :page_into=>nil
    #   }, :link=>"/menu", :link_text=>"Menu", "children"=>[]
    # }
    def build_nav(child_hash, pathnames, parent_link)
      parent_link = if child_hash['child_type'] == 'Page'
                      path_finder(pathnames, child_hash)[:path]
                    else
                      parent_link
                    end
      menu_hash = case child_hash['child_type']
                  when 'Page'
                    build_page_nav(child_hash, pathnames)
                  when 'Header'
                    build_header_nav(child_hash)
                  when 'Custom Link'
                    build_custom_link_nav(child_hash)
                  when 'Anchor'
                    build_anchor_link_nav(child_hash, parent_link)
                  end
      menu_hash['children'] = child_hash['children'].map do |hash|
        build_nav(hash, pathnames, parent_link)
      end
      menu_hash
    end

    def build_page_nav(hash, pathnames)
      {
        title: hash['title'],
        image: {
          nav_image: hash['image_id'],
          page_image: hash['page_header_image'] },
        text: {
          text: hash['text'], page_header: hash['page_header'],
          page_into: hash['page_into']
        },
        link: path_finder(pathnames, hash)[:path],
        link_text: hash['link_text'] ? hash['link_tex'] : hash['title']
      }
    end

    def build_header_nav(hash)
      {
        title: hash['title'], image: { nav_image: hash['image_id'] },
        text: hash['text'], link: hash['link'], link_text: hash['link_text']
      }
    end

    def build_custom_link_nav(hash)
      {
        title: hash['title'], image: { nav_image: hash['image_id'] },
        text: hash['text'], link: hash['link'], link_text: hash['link_text']
      }
    end

    def build_anchor_link_nav(hash, parent_link)
      {
        title: hash['title'], image: { nav_image: hash['image_id'] },
        text: hash['text'], link: parent_link + hash['link'],
        link_text: hash['link_text']
      }
    end

    # example result
    # {:page_id=>1, :path=>"/page-1"}
    def path_finder(pathnames, hash)
      pathnames.select do |path|
        path[:page_id] == hash['page_id']
      end[0]
    end
  end
end
