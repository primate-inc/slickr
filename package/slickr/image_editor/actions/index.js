import request from 'superagent';
let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

export const updateCropData = crop_object => {
  let params = {};
  params[_csrf_param()] = _csrf_token()
  return function(dispatch, getState) {
    dispatch({
      type: 'CHANGE_CROP',
      payload: crop_object
    })
  }
}

export const updateImage = formData => {

  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params["image"] = {}
    params["image"] = formData
    params["image"]["crop_data"] = getState().imageState.crop_data
    request.put(getState().imageState.admin_update_path).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'UPDATE_IMAGE',
          payload: resp.body
        })
      }
    })
  }
}
