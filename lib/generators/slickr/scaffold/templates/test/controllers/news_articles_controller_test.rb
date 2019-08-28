require "test_helper"

class NewsArticlesControllerTest < ActionController::TestCase
  context 'routes' do
    should route(:get, '/news')
      .to(controller: :news, action: :index)
    should route(:get, '/news/example-article')
      .to(controller: :news, action: :show, id: 'example-article')
  end
  context 'GET #index' do
    context 'response code' do
      setup { get :index }
      should respond_with 200
    end
    context 'templates' do
      setup { get :index }
      should render_template('index')
      should render_template(partial: 'news/filters/_filters')
      should render_template(partial: 'news/listing/_listing')
    end
  end
  context 'GET #show' do
    context 'response code' do
      setup do
        get :show, params: { id: 'example-article' }
      end
      should respond_with 200
    end
    context 'basic template' do
      setup do
        get :show, params: { id: 'example-article' }
      end
      should render_template('show')
      should render_template(partial: 'modules/hero/_hero-news')
    end
  end
end
