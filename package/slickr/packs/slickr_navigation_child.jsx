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

const navigationState = document.getElementById('navigation-data')
                                .dataset.navigation_data
const parent = document.getElementById('navigation-data').dataset.parent
const rootNav = document.getElementById('navigation-data').dataset.root_nav
const childTypes = document.getElementById('navigation-data')
                           .dataset.child_types
const selectablePages = document.getElementById('navigation-data')
                                .dataset.selectable_pages
const allowedUploadInfo = document.getElementById('navigation-data')
                                  .dataset.allowed_upload_info

const initialState = {
  navigationState: JSON.parse(navigationState),
  parent: JSON.parse(parent),
  rootNav: JSON.parse(rootNav),
  childTypes: JSON.parse(childTypes),
  selectablePages: JSON.parse(selectablePages),
  modalIsOpen: false,
  loadedImages: {},
  allowedUploadInfo: JSON.parse(allowedUploadInfo)
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
