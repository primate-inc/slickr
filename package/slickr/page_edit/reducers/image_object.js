const imageObject = (state = {}, action) => {
  switch(action.type) {
    case 'CHOOSE_ACTIVEADMIN_IMAGE':
      return Object.assign({}, state, {
        id: action.payload.id, path: action.payload.path
      })
    default:
      return state
  }
}

export default imageObject
