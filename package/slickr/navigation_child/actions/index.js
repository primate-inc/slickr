import request from 'superagent';

let _csrf_param = () => {
  return document.getElementsByName("csrf-param")[0].content
}
let _csrf_token = () => {
  return document.getElementsByName("csrf-token")[0].content
}

export const updateNavigationChildContent = values => {
  return function(dispatch, getState) {
    let params = {"slickr_navigation":{}};
    params[_csrf_param()] = _csrf_token()
    for (var key in values) {
      if (values.hasOwnProperty(key)) {
        params["slickr_navigation"][key] = values[key];
      }
    }
    params["slickr_navigation"]["parent_id"] = getState().parent.id;
    let method, url;
    if(getState().navigationState.id == null) {
      method = 'post'
      url = 'admin_create_navigation_path'
    } else {
      method = 'put'
      url = 'admin_update_navigation_path'
    }

    request[method](getState().navigationState[url])
           .type('json').accept('json')
           .send(params)
           .end(function(err,resp){
      if(err) {
        let flash = document.getElementsByClassName('flashes')[0]
        flash.insertAdjacentHTML(
          'beforeend',
          '<div id="save_message" class="flash flash_alert">Error</div>'
        );
        setTimeout(function() {
          document.getElementById('save_message').className += " hide";
        }, 1000);
        setTimeout(function() {
          document.getElementById('save_message').remove();
        }, 1500);
      } else {
        let flash = document.getElementsByClassName('flashes')[0]
        flash.insertAdjacentHTML(
          'beforeend',
          '<div id="save_message" class="flash flash_notice">Saved</div>'
        );
        setTimeout(function() {
          document.getElementById('save_message').className += " hide";
        }, 1000);
        setTimeout(function() {
          document.getElementById('save_message').remove();
          window.location.href = getState().rootNav.url;
        }, 1500);

      }
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

export const toggleChoosingImage = () => {
  return function(dispatch, getState) {
    dispatch({
      type: "TOGGLE_CHOOSING_IMAGE"
    })
  }
}

export const loadImages = (page) => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().navigationState.admin_image_index_path)
           .set('Accept', 'text/html')
           .query(`type=page_edit&page=${page}`)
           .end(function(err,resp){
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

export const keepCurrentPage = () => {
  return function(dispatch, getState) {
    dispatch({
      type: 'KEEP_CURRENT_PAGE'
    })
  }
}

export const updateNavImage = imageData => {
  return function(dispatch, getState) {
    dispatch({
      type: "CHOOSE_NAV_IMAGE",
      payload: imageData
    })
  }
}
