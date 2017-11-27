import request from 'superagent';
import {editorStateToJSON, DraftJS} from "megadraft";

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

export const updatePageContent = values => {
  return function(dispatch, getState) {
    let params = {"page":{}};
    params[_csrf_param()] = _csrf_token()
    for (var key in values) {
      if (values.hasOwnProperty(key)) {
        params["page"][key] = values[key];
      }
    }
    params["page"]["content"] = JSON.parse(editorStateToJSON(getState().editorState))

    request.put(getState().pageState.admin_page_path).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        let flash = document.getElementsByClassName('flashes')[0]
        flash.insertAdjacentHTML( 'beforeend', '<div id="save_message" class="flash flash_notice">Saved</div>' );
        setTimeout(function() {
          document.getElementById('save_message').className += " hide";
        }, 1000);
        setTimeout(function() {
          document.getElementById('save_message').remove();
        }, 1500);
        dispatch({
          type: 'SET_PAGE_TITLE',
          title: resp.body.title
        })
      }
    })
  }
}

export const toggleScheduling = () => {
  return function(dispatch, getState) {
    dispatch({
      type: getState().schedulingActive ? 'HIDE_SCHEDULING' : 'SHOW_SCHEDULING'
    })
  }
}

export const startScheduling = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "SHOW_SCHEDULING"
    })
  }
}

export const unschedule = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "UNSCHEDULE"
    })
  }
}

export const cancelScheduling = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "HIDE_SCHEDULING"
    })
  }
}

export const saveSchedule = (date) => {
  return function(dispatch, getState) {
    dispatch({
      type: "SAVE_SCHEDULE",
      payload: date
    })
    dispatch({
      type: "HIDE_SCHEDULING"
    })
  }
}

export const setNewPublishingSchedule = (date) => {
  return function(dispatch, getState) {
    dispatch({
      type: "HIDE_SCHEDULING"
    })
    dispatch({
      type: "SET_PUBLISHING_DATE",
      date: date
    })
  }
}

export const setPageTitle = text => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params["page"] = {}
    params["page"]["title"] = text

    request.put(getState().pageState.admin_page_path).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        console.log(resp.body.title)
        dispatch({
          type: 'SET_PAGE_TITLE',
          title: resp.body.title
        })
      }
    })

  }
}

export const pageUnpublish = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.put(getState().pageState.admin_unpublish_path).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'UNPUBLISH_PAGE',
          aasm_state: resp.body.aasm_state
        })
      }
    })
  }
}

export const pagePublish = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.put(getState().pageState.admin_publish_path).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'PUBLISH_PAGE',
          aasm_state: resp.body.aasm_state
        })
      }
    })
  }
}

export const changeTab = (tab) => {
  return function(dispatch, getState) {
    dispatch({
      type: "CHANGE_TAB",
      payload: tab
    })
  }
}

export const toggleImagePicker = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "TOGGLE_MODAL"
    })
  }
}

export const loadImages = selectedImageIds => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_image_index_path).set('Accept', 'text/html').query('type=page_edit').end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_IMAGES',
          payload: resp.body
        })
      }
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

export const loadBooks = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_book_index_path).set('Accept', 'text/html').query('type=megadraft_books').end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_BOOKS',
          payload: resp.body
        })
      }
    })
  }
}

export const loadAuthors = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_author_index_path).set('Accept', 'text/html').query('type=megadraft_authors').end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_AUTHORS',
          payload: resp.body
        })
      }
    })
  }
}
