require "test_helper"

class PeopleControllerTest < ActionController::TestCase
  context 'routes' do
    should route(:get, '/people')
      .to(controller: :people, action: :index)
    should route(:get, '/people/example-person')
      .to(controller: :people, action: :show, id: 'example-person')
  end
  context 'GET #index' do
    context 'response code' do
      setup { get :index }
      should respond_with 200
    end
    context 'templates' do
      setup { get :index }
      should render_template('index')
    end
  end
  context 'GET #show' do
    context 'response code' do
      setup do
        get :show, params: { id: 'example-person' }
      end
      should respond_with 200
    end
    context 'basic template' do
      setup do
        get :show, params: { id: 'example-person' }
      end
      should render_template('show')
    end
  end
end
