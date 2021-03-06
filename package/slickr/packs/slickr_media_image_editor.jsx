import React from 'react'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import ImageEditor from '../media_image_editor/containers/image_editor.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../media_image_editor/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

const imageData = document.getElementById("image-data").dataset.image_data

const initialState = {
  imageState: Object.assign(
    {},
    JSON.parse(imageData),
    {crop_data: {x: null, y: null, width: null, height: null}}
  )
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(
  reducers, initialState, applyMiddleware(...middlewares)
)

document.addEventListener('DOMContentLoaded', () => {
  render(
    <Provider store={store}>
      <ImageEditor />
    </Provider>,
    document.getElementById('image-editing-form')
  )
})
