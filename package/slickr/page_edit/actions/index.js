import request from 'superagent';
import {editorStateToJSON, DraftJS} from "megadraft";

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

export const toggleImagePicker = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "TOGGLE_MODAL"
    })
  }
}

export const toggleChoosingPageHeaderImage = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "TOGGLE_CHOOSING_PAGE_HEADER_IMAGE"
    })
  }
}

export const toggleChoosingActiveAdminImage = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "TOGGLE_CHOOSING_ACTIVEADMIN_IMAGE"
    })
  }
}

export const loadImages = (page) => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_image_index_path).set('Accept', 'text/html').query(`type=page_edit&page=${page}`).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_IMAGES',
          payload: JSON.parse(resp.text)
        })
        dispatch({
          type: 'CANCEL_LOADER'
        })
      }
    })
  }
}

export const showLoader = () => {
  return function(dispatch, getState) {
    dispatch({
      type: 'SHOW_LOADER'
    })
  }
}

export const changeEditorState = editorState => {
  return function(dispatch, getState) {
    dispatch({
      type: "CHANGE_EDITOR_STATE",
      payload: editorState
    })
  }
}

export const updatePageHeaderImage = imageData => {
  return function(dispatch, getState) {
    dispatch({
      type: "CHOOSE_PAGE_HEADER_IMAGE",
      payload: imageData
    })
  }
}

export const updateActiveAdminImage = imageData => {
  return function(dispatch, getState) {
    dispatch({
      type: "CHOOSE_ACTIVEADMIN_IMAGE",
      payload: imageData
    })
  }
}
