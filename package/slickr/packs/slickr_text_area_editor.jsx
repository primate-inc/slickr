import React from 'react'
import { render } from 'react-dom'
import TextArea from '../text_area_editor/containers/text_area_edit.jsx'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import reducers from '../page_edit/reducers';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import {DraftJS, editorStateFromRaw, createTypeStrategy} from "megadraft";
import Link from "megadraft/lib/components/Link"
import mainAppDecorators from 'slickr_extensions/page_edit/additional_megadraft_decorators.js'
import { genKey } from 'draft-js'

let storeArray = []

const emptyDraftObject = {
  entityMap: {},
  blocks: [
    {
      key: genKey(),
      text: '',
      type: 'unstyled',
      depth: 0,
      inlineStyleRanges: [],
      entityRanges: [],
      data: {}
    }
  ]
}

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementsByClassName('megadraft-text-editor')[0]) {
    const pageState = JSON.parse(
      document.getElementsByClassName('megadraft-text-editor')[0]
      .childNodes[0]
      .getAttribute('data')
    ).pageState

    let elements = document.getElementsByClassName('megadraft-text-editor')
    Array.prototype.forEach.call(elements, function(element, index) {
      const nextElementSibling = element.nextElementSibling
      const label = nextElementSibling.querySelector('label')
      const textArea = nextElementSibling.querySelector('textarea')

      const dataNode = element.childNodes[0]
      let data = JSON.parse(dataNode.getAttribute('data'))

      const required = data.input.required
      let labelText = data.input.label
      if(required) { labelText = `${labelText}*` }

      if(data.input.field === '') {
        data.input.field = emptyDraftObject
      } else {
        data.input.field = JSON.parse(data.input.field)
      }

      const decorators = [
        {
          strategy: createTypeStrategy("LINK"),
          component: Link
        }
      ]

      const mergedDecorators = decorators.concat(mainAppDecorators);

      const compositeDecorator = new DraftJS.CompositeDecorator(mergedDecorators)

      const initialState = {
        pageState: JSON.parse(pageState),
        textAreaIndex: index,
        label: label,
        labelText: labelText,
        textArea: textArea,
        modalIsOpen: false,
        loadedImages: {},
        editorState: editorStateFromRaw(data.input.field, compositeDecorator)
      }

      const middlewares = [thunk];
      if (process.env.NODE_ENV === `development`) {
        middlewares.push(logger);
      }
      const store = createStore(reducers, initialState, applyMiddleware(...middlewares))
      storeArray.push(store)

      render(
        <Provider store={store}>
          <TextArea />
        </Provider>,
        nextElementSibling
      )

    })
  }
})

export default storeArray
