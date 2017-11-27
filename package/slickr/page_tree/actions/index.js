import request from 'superagent';
let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }
export const updateTree = tree => {
  return function(dispatch, getState) {
    dispatch({type:"UPDATE_TREE", payload:tree})
  }
}

export const saveNodePosition = (node, parent_id, previous_id) => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params["parent_id"] = parent_id
    params["previous_id"] = previous_id
    request.put(node.change_position_admin_page).type('json').accept('json').send(params).end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'PAGES_UPDATED',
          title: resp.body
        })
      }
    })
  }
}
