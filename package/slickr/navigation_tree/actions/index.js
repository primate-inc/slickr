import request from 'superagent';
let _csrf_param = () => {
  return document.getElementsByName("csrf-param")[0].content
}
let _csrf_token = () => {
  return document.getElementsByName("csrf-token")[0].content
}

export const updateTree = tree => {
  return function(dispatch, getState) {
    dispatch({type:"UPDATE_TREE", payload:tree})
  }
}

export const saveNodePosition = (node, parent_id, new_position) => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params['parent_id'] = parent_id
    params['new_position'] = new_position
    request.put(node.change_position_admin_navigation)
           .type('json')
           .accept('json')
           .send(params)
           .end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'NAVIGATION_POSITION_UPDATED',
          payload: resp.body
        })
      }
    })
  }
}

export const deleteNavigation = (path) => {
  return function(dispatch, getState) {
    let params = {};
    params[_csrf_param()] = _csrf_token()
    params['root_title'] = getState().treeState[0].title;
    request.delete(path)
           .type('json')
           .accept('json')
           .send(params)
           .end(function(err,resp){
      if(err) {
        console.error(err)
      } else {
        dispatch({
          type: 'UPDATE_TREE',
          payload: resp.body
        })
        if(resp.body.length == 0) {
          window.location.href = window.location.pathname
        }
      }
    })
  }
}
