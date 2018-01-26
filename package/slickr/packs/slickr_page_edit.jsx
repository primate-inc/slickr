import React from 'react'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import PageEditor from '../page_edit/containers/page_editor'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../page_edit/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import {DraftJS, editorStateFromRaw, createTypeStrategy} from "megadraft";
import Link from "megadraft/lib/components/Link"
// import mainAppDecorators from 'slickr_extensions/page_edit/additional_megadraft_decorators.js'
import ReactModal from 'react-modal';

const pageState = document.getElementById('page-data') ? document.getElementById('page-data').dataset.page_data : '{"":""}'

const decorators = [
  {
    strategy: createTypeStrategy("LINK"),
    component: Link
  }
]

// const mergedDecorators = decorators.concat(mainAppDecorators);
//
// const compositeDecorator = new DraftJS.CompositeDecorator(mergedDecorators)
const compositeDecorator = new DraftJS.CompositeDecorator(decorators)

const initialState = {
  pageState: JSON.parse(pageState),
  activeTab: 'content',
  modalIsOpen: false,
  loadedImages: {},
  editorState: editorStateFromRaw(JSON.parse(pageState).content, compositeDecorator)
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(reducers, initialState, applyMiddleware(...middlewares))

if (window.location.pathname.indexOf('/slickr_pages/') && window.location.pathname.indexOf('/slickr_pages/') !== -1) {
  document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('title_bar').remove()
    if(document.getElementById('wrapper')) {
      document.getElementById('wrapper').id = 'custom-wrapper'
    }

    render(
      <Provider store={store}>
        <PageEditor />
      </Provider>,
      document.getElementById("page_edit_content")
    )
  })
}

export default store
