import request from 'superagent';

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

export const loadAdmins = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_user_index_path).set('Accept', 'text/html').query('type=megadraft_admins').end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_ADMINS',
          payload: resp.body
        })
      }
    })
  }
}
