import React from 'react';
import { render } from 'react-dom';
import PropTypes from 'prop-types';
import ImageGallery from '../media_gallery/containers/media_gallery.jsx';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import reducers from '../media_gallery/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

const imageData = document.getElementById('media-data-array').dataset.media_data_array

const loadedImages = {
  loadedImages: JSON.parse(imageData)
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(reducers, loadedImages, applyMiddleware(...middlewares))

document.addEventListener('DOMContentLoaded', () => {
  render(
    <Provider store={store}>
      <ImageGallery />
    </Provider>,
    document.getElementById("media-gallery")
  )
})
