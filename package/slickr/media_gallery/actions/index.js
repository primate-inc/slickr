import request from 'superagent';
import pdfPlaceholder from '../files/pdf_image.jpg';
require('es6-promise/auto');
import browserImageSize from 'browser-image-size'
let _csrf_param = () => {
  return document.getElementsByName("csrf-param")[0].content
}
let _csrf_token = () => {
  return document.getElementsByName("csrf-token")[0].content
}

export const toggleIsSelected = selectedImageId => {
  return function(dispatch, getState) {
    dispatch({
      type: 'TOGGLE_IS_SELECTED',
      payload: selectedImageId
    })
  }
}

export const addSelectedImage = selectedImage => {
  return function(dispatch, getState) {
    dispatch({
      type: 'ADD_SELECTED_IMAGE',
      payload: selectedImage
    })
  }
}

export const removeSelectedImage = selectedImageId => {
  return function(dispatch, getState) {
    dispatch({
      type: 'REMOVE_SELECTED_IMAGE',
      payload: selectedImageId
    })
  }
}

export const clearAllSelected = selectedImageIds => {
  return function(dispatch, getState) {
    dispatch({
      type: 'CLEAR_ALL_SELECTED',
      payload: selectedImageIds
    })
  }
}

export const deleteSelectedImages = selectedImageIds => {
  return function(dispatch, getState) {
    let urlParams = new URLSearchParams(window.location.search);
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params['batch_action'] = 'destroy'
    params['batch_action_inputs'] = '{}'
    params['collection_selection_toggle_all'] = 'on'
    params['collection_selection'] = selectedImageIds.map(String)
    if(urlParams.has('page')) {
      params['page'] = urlParams.get('page')
    } else {
      params['page'] = '1'
    }

    request.post(getState().loadedImages[0].admin_batch_delete_path)
           .type('json').accept('json').send(params).end(function(err,resp) {
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'DELETE_SELECTED_IMAGES',
          payload: resp.body
        })
      }
    })
  }
}

export const createImage = payload => {
  const random = Math.random().toString(36).substring(7);
  let preview;
  return function(dispatch, getState) {
    if(payload.file.type === 'application/pdf') {
      preview = pdfPlaceholder
    } else {
      preview = payload.file.preview
    }
    browserImageSize(preview)
      .then(function (size) {
        return size
      })
      .then(function (size) {
        dispatch(addUpload(uploadArrayObject(payload, random, size)))
      })
      .then(function () {
        payload.formData.append(_csrf_param(), _csrf_token())
        request.post('/admin/slickr_media_uploads')
          .send(payload.formData).set('Accept', 'application/json')
          .on('progress', function(e){
            dispatch(updateUploadProgress({
              id: random, uploadProgressValue: e.percent, state: getState()
            }))
          })
          .end(function(err,resp){
            if(err) {
              dispatch(updateUploadState({id: random, state: 'error', storeState: getState()}))
            } else {
              dispatch({
                type: 'ADD_TO_LOADED_IMAGES',
                payload: {body: resp.body, id: random}
              })
            }
          })
      })
  }
}

export function uploadProgress(data) {
  let state, img, newArray;
  if(data.state.loadedImages) {
    state = checkIfLoadedImagesArray(data.state.loadedImages, data.id)
    img = state[state.findIndex(x => x.id == data.id)];
    newArray = removeImageFromArray(state, data.id)

    if(img !== undefined) {
      if(data.uploadProgressValue !== undefined) {
        var newImg = Object.assign(
          {},img, { uploadProgressValue: data.uploadProgressValue }
        )
      } else {
        var newImg = Object.assign({},img)
      }
      newArray.unshift(newImg)
      return newArray;
    } else {
      return state;
    }
  } else {
    state = checkIfLoadedImagesArray(data.storeState.loadedImages)
    img = state[state.findIndex(x => x.id == data.id)];
    newArray = removeImageFromArray(state, data.id)
    var newImg = Object.assign({},img, { state: 'error' })
    newArray.unshift(newImg)
    return newArray;
  }
}

function checkIfLoadedImagesArray(loadedImages) {
  if(loadedImages.constructor == Array) {
    // if uploaded from the MediaGallery
    return loadedImages
  } else {
    // if uploaded through the image_picker_modal component
    return loadedImages.images
  }
}

function removeImageFromArray(state, id) {
  let newArray = state.slice();
  newArray.splice(newArray.findIndex(x => x.id == id), 1);
  return newArray
}

export function addUpload(upload) {
  return {
    type: 'ADD_UPLOAD',
    payload: upload
  }
}

export function updateUploadProgress(data) {
  var payload = uploadProgress(data)
  return {
    type: 'UPDATE_UPLOAD_PROGRESS',
    payload: payload
  }
}

export function updateUploadState(data) {
  var payload = uploadProgress(data)
  return {
    type: 'UPDATE_UPLOAD_STATE',
    payload: payload
  }
}

// helper functions

export function uploadArrayObject(payload, random, size) {
 return {
   id: random,
   state: 'started',
   upload: payload.upload,
   build_for_gallery : buildForGallery(payload, size),
   additional_info: {'alt_text': ''},
   uploadProgressValue: 0
 }
}

export function buildForGallery(payload, size) {
  let preview
  if(payload.file.type === 'application/pdf') {
    preview = pdfPlaceholder
  } else {
    preview = payload.file.preview
  }
  return {
    id: Math.floor(Math.random() * 1000000000),
    src: payload.file.preview,
    thumbnail: preview,
    caption: '',
    thumbnailWidth: size.width,
    thumbnailHeight: size.height,
    isSelected: false,
    editPath: ''
  }
}
