import React from 'react'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import NavigationEditor from '../navigation_child/containers/navigation_editor.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../navigation_child/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import ReactModal from 'react-modal';

const navigationState = document.getElementById('navigation-data').dataset.navigation_data
const childParent = document.getElementById('navigation-data').dataset.child_parent
const childTypes = document.getElementById('navigation-data').dataset.child_types

const initialState = {
  navigationState: JSON.parse(navigationState),
  childParent: JSON.parse(childParent),
  childTypes: JSON.parse(childTypes),
  modalIsOpen: false,
  loadedImages: {}
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(reducers, initialState, applyMiddleware(...middlewares))

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('title_bar').remove()
  if(document.getElementById('wrapper')) {
    document.getElementById('wrapper').id = 'custom-wrapper'
  }
  render(
    <Provider store={store}>
      <NavigationEditor />
    </Provider>,
    document.getElementById("navigation_child_content")
  )
})

export default store
