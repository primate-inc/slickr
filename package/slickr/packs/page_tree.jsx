// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import Tree from '../page_tree/containers/tree_component'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../page_tree/reducers';
import thunk from 'redux-thunk';

const treeData = document.getElementById("page_tree_content").dataset.pages

const initialState = {
  treeState: JSON.parse(treeData)
}

const store = createStore(reducers, initialState, applyMiddleware(thunk))

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('index_footer').remove()
  ReactDOM.render(
    <Provider store={store}>
      <Tree />
    </Provider>,
    document.getElementById("dashboard_content")
  )
})
