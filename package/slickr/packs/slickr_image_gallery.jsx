// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import { render } from 'react-dom';
import PropTypes from 'prop-types';
import ImageGallery from '../image_gallery/containers/image_gallery';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import reducers from '../image_gallery/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

const imageData = document.getElementById("image-data-array").dataset.image_data_array

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
    document.getElementById("image-gallery")
  )
})
