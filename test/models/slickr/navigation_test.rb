# frozen_string_literal: true

class Slickr::NavigationTest < ActiveSupport::TestCase
  def setup
    @master_navigation = Slickr::Navigation.new(
                           title: 'MasterNav'
                         )

    @main_navigation = Slickr::Navigation.new(
                         parent: @master_navigation,
                         ancestry: 1,
                         root_type: 'Root',
                         title: 'MainNav'
                       )
    @main_navigation.save
  end

  def test_navigation_can_be_valid
    assert @main_navigation.valid?
  end

  def test_root_navigation_can_have_children
    @child_navigation = Slickr::Navigation.new(
                          parent: @main_navigation,
                          child_type: 'Page',
                          title: 'Page 1',
                          slickr_page: slickr_pages(:page_1)
                        )
    @child_navigation.save

    assert_includes @main_navigation.children,
                    @child_navigation
  end

  def test_page_navigation_can_have_children
    @page_navigation = Slickr::Navigation.new(
                         parent: @main_navigation,
                         child_type: 'Page',
                         title: 'Page 1',
                         slickr_page: slickr_pages(:page_1)
                       )
    @page_navigation.save
    @child_navigation = Slickr::Navigation.new(
                         parent: @page_navigation,
                         child_type: 'Page',
                         title: 'Page 2',
                         slickr_page: slickr_pages(:page_2)
                       )
    @child_navigation.save

    assert_includes @page_navigation.children,
                    @child_navigation
  end

  def test_header_navigation_can_have_children
    @header_navigation = Slickr::Navigation.new(
                         parent: @main_navigation,
                         child_type: 'Header',
                         title: 'Page 1'
                       )
    @header_navigation.save
    @child_navigation = Slickr::Navigation.new(
                         parent: @header_navigation,
                         child_type: 'Page',
                         title: 'Page 1',
                         slickr_page: slickr_pages(:page_1)
                       )
    @child_navigation.save

    assert_includes @header_navigation.children,
                    @child_navigation
  end

  def test_custom_link_navigation_cannot_have_children
    @custom_link_navigation = Slickr::Navigation.new(
                                parent: @main_navigation,
                                child_type: 'Custom Link',
                                title: 'Custom Link',
                                link: '/custom-link'
                              )
    @custom_link_navigation.save
    @child_navigation = Slickr::Navigation.new(
                          parent: @custom_link_navigation,
                          child_type: 'Page',
                          title: 'Child',
                          slickr_page: slickr_pages(:page_1)
                        )

    assert @child_navigation.invalid?
  end

  def test_page_navigation_with_children_cannot_become_custom_link
    @page_navigation = Slickr::Navigation.new(
                         parent: @main_navigation,
                         child_type: 'Page',
                         title: 'Page 1',
                         slickr_page: slickr_pages(:page_1)
                       )
    @page_navigation.save
    @child_navigation = Slickr::Navigation.new(
                         parent: @page_navigation,
                         child_type: 'Page',
                         title: 'Page 2',
                         slickr_page: slickr_pages(:page_2)
                       )
    @child_navigation.save

    @page_navigation.update(child_type: 'Custom Link')

    assert @page_navigation.invalid?
  end

  def test_all_nav_trees_is_valid
    @page_navigation = Slickr::Navigation.new(
                         parent: @main_navigation,
                         child_type: 'Page',
                         title: 'Page 1',
                         slickr_page: slickr_pages(:page_1)
                       )
    @page_navigation.save
    @child_navigation = Slickr::Navigation.new(
                         parent: @page_navigation,
                         child_type: 'Page',
                         title: 'Page 2',
                         slickr_page: slickr_pages(:page_2)
                       )
    @child_navigation.save

    @all_nav_trees = Slickr::Navigation.all_nav_trees

    assert @all_nav_trees
  end
end
