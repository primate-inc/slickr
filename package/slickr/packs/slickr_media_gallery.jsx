import React from 'react';
import { render } from 'react-dom';
import PropTypes from 'prop-types';
import ImageGallery from '../media_gallery/containers/media_gallery.jsx';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import reducers from '../media_gallery/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

const imageData = document.getElementById('media-data-array')
                          .dataset.media_data_array
const allowedUploadInfo = document.getElementById('media-data-array')
                                  .dataset.allowed_upload_info
const additionalInfo = document.getElementById('media-data-array')
                               .dataset.additional_info

const imagesAndInfo = {
  loadedImages: JSON.parse(imageData),
  allowedUploadInfo: JSON.parse(allowedUploadInfo),
  additionalInfo: JSON.parse(additionalInfo)
}

const middlewares = [thunk];
if (process.env.NODE_ENV === `development`) {
  middlewares.push(logger);
}
const store = createStore(
  reducers, imagesAndInfo, applyMiddleware(...middlewares)
)

document.addEventListener('DOMContentLoaded', () => {
  render(
    <Provider store={store}>
      <ImageGallery />
    </Provider>,
    document.getElementById("media-gallery")
  )
})
