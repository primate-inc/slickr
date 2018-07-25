import React from 'react'
import { render } from 'react-dom'
import ActiveadminImagePick from '../activeadmin_image_picker/containers/activeadmin_image_pick.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../page_edit/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';

let storeArray = []

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementsByClassName('image-picker')[0]) {
    const pageState = JSON.parse(
      document.getElementsByClassName('image-picker')[0]
      .childNodes[0]
      .getAttribute('data')
    ).pageState

    const allowedUploadInfo = JSON.parse(
      document.getElementsByClassName('image-picker')[0]
      .childNodes[0]
      .getAttribute('data')
    ).allowedUploadInfo

    let elements = document.getElementsByClassName('image-picker')
    Array.prototype.forEach.call(elements, function(element, index) {
      const nextElementSibling = element.nextElementSibling
      const label = nextElementSibling.querySelector('label')
      const textArea = nextElementSibling.querySelector('textarea')

      const dataNode = element.childNodes[0]
      let data = JSON.parse(dataNode.getAttribute('data'))
      
      const initialState = {
        pageState: JSON.parse(pageState),
        allowedUploadInfo: allowedUploadInfo,
        imageObject: data.input,
        textAreaIndex: index,
        label: label,
        textArea: textArea
      }

      const middlewares = [thunk];
      if (process.env.NODE_ENV === `development`) {
        middlewares.push(logger);
      }

      const store = createStore(
        reducers, initialState, applyMiddleware(...middlewares)
      )
      storeArray.push(store)

      render(
        <Provider store={store}>
          <ActiveadminImagePick />
        </Provider>,
        nextElementSibling
      )
    })
  }
})

export default storeArray
