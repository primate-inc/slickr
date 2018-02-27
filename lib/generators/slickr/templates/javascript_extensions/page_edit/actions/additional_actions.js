import request from 'superagent';

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

export const loadPdfs = () => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()

    request.get(getState().pageState.admin_pdfs_path).set('Accept', 'text/html').end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'LOAD_PDFS',
          payload: resp.body
        })
      }
    })
  }
}
