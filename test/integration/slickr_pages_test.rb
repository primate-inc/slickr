require 'test_helper'

class DummyTestClass
  include Kubik::KubikPreviewable
end

class SlickrPagesTest < ActionDispatch::IntegrationTest

  test 'has basic previewable route' do
    Slickr::Page.create!(title: 'Test page', layout: 'standard')
    assert_generates '/admin/slickr_pages/test-page/preview_slickr_page', controller: 'admin/slickr_pages', action: 'preview_slickr_page', id: 'test-page'
  end

  test 'responds to slickr_previewable_locals' do
    page = DummyTestClass.new
    assert_respond_to(page, :slickr_previewable_locals)
  end

  test 'defaults for slickr_previewable_locals' do
    page = DummyTestClass.new
    assert_equal({}, page.slickr_previewable_locals)
  end

  test 'defaults override with fixed value for slickr_previewable_locals' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(locals: {foo: :bar})
    end
    page = klass.new
    assert_equal({ foo: :bar }, page.slickr_previewable_locals)
  end

  test 'defaults override with proc value for slickr_previewable_locals' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(
        locals: lambda { |d|
          { foo: d.get_foo }
        }
      )
      def get_foo
        :bar
      end
    end
    page = klass.new
    assert_equal({ foo: :bar }, page.slickr_previewable_locals)
  end


  test 'responds to slickr_previewable_layout' do
    page = DummyTestClass.new
    assert_respond_to(page, :slickr_previewable_layout)
  end

  test 'defaults for slickr_previewable_layout' do
    page = DummyTestClass.new
    assert_equal('layouts/application', page.slickr_previewable_layout)
  end

  test 'defaults override with fixed value for slickr_previewable_layout' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(layout: 'layouts/different_layout')
    end
    page = klass.new
    assert_equal('layouts/different_layout', page.slickr_previewable_layout)
  end

  test 'defaults override with proc value for slickr_previewable_layout' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(
        layout: lambda { |d| d.get_template }
      )
      def get_template
        "layouts/#{2+2}_testing"
      end
    end
    page = klass.new
    assert_equal('layouts/4_testing', page.slickr_previewable_layout)
  end

  test 'responds to slickr_previewable_template' do
    page = DummyTestClass.new
    assert_respond_to(page, :slickr_previewable_template)
  end

  test 'defaults for slickr_previewable_template' do
    page = DummyTestClass.new
    assert_equal('dummy_test_classes/show', page.slickr_previewable_template)
  end

  test 'defaults override with fixed value for slickr_previewable_template' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(template: 'test/different_template')
    end
    page = klass.new
    assert_equal('test/different_template', page.slickr_previewable_template)
  end

  test 'defaults override with proc value for slickr_previewable_template' do
    klass = Class.new do
      def self.name
        'Dummy'
      end
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      include Kubik::KubikPreviewable
      slickr_previewable(
        template: lambda { |d| d.get_template }
      )
      def get_template
        "test/#{2+2}_testing"
      end
    end
    page = klass.new
    assert_equal('test/4_testing', page.slickr_previewable_template)
  end

  test 'responds to slickr_previewable_instance_variables' do
    page = DummyTestClass.new
    assert_respond_to(page, :slickr_previewable_instance_variables)
  end

  test 'defaults for slickr_previewable_instance_variables' do
    page = DummyTestClass.new
    assert_equal([], page.slickr_previewable_instance_variables)
  end
end
