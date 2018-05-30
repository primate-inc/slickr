import React from 'react'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import Tree from '../navigation_tree/containers/tree_component.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../navigation_tree/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

const treeData = document.getElementById("navigation_tree_content").dataset.pages

const initialState = {
  treeState: JSON.parse(treeData)
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(reducers, initialState, applyMiddleware(...middlewares))

document.addEventListener('DOMContentLoaded', () => {
  render(
    <Provider store={store}>
      <Tree />
    </Provider>,
    document.getElementById("dashboard_content")
  )
})
