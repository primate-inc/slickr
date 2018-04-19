import React from 'react'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import Tree from '../navigation_tree/containers/tree_component.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../page_tree/reducers';
import thunk from 'redux-thunk';

const treeData = document.getElementById("navigation_tree_content").dataset.pages

const initialState = {
  treeState: JSON.parse(treeData)
}

const store = createStore(reducers, initialState, applyMiddleware(thunk))

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('index_footer').remove()
  render(
    <Provider store={store}>
      <Tree />
    </Provider>,
    document.getElementById("dashboard_content")
  )
})
