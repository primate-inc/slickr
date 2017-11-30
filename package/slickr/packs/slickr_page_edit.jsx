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

const pageData = document.getElementById("page-data").dataset.page_data

const myDecorator = new DraftJS.CompositeDecorator([
  {
    strategy: createTypeStrategy("LINK"),
    component: Link
  }
])

const initialState = {
  pageState: JSON.parse(pageData),
  activeTab: 'content',
  modalIsOpen: false,
  loadedImages: [],
  editorState: editorStateFromRaw(JSON.parse(pageData).content, myDecorator)
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(reducers, initialState, applyMiddleware(...middlewares))

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('title_bar').remove()
  document.getElementById('wrapper').id = 'custom-wrapper'
  render(
    <Provider store={store}>
      <PageEditor />
    </Provider>,
    document.getElementById("page_edit_content")
  )
})

export default store
