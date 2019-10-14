require "test_helper"

class EventsControllerTest < ActionController::TestCase
  context 'routes' do
    should route(:get, '/events')
      .to(controller: :news, action: :index)
    should route(:get, '/events/example-event')
      .to(controller: :news, action: :show, id: 'example-event')
  end
  context 'GET #index' do
    context 'response code' do
      setup { get :index }
      should respond_with 200
    end
    context 'templates' do
      setup { get :index }
      should render_template('index')
      should render_template(partial: 'events/filters/_filters')
      should render_template(partial: 'events/listing/_listing')
    end
  end
  context 'GET #show' do
    context 'response code' do
      setup do
        get :show, params: { id: 'example-event' }
      end
      should respond_with 200
    end
    context 'basic template' do
      setup do
        get :show, params: { id: 'example-event' }
      end
      should render_template('show')
    end
  end
end
