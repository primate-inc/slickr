const imageState = (state = {}, action) => {
  switch(action.type) {
    case 'SET_IMAGE_URL':
      return Object.assign({},state, { url: action.url })
    case 'CHANGE_CROP':
      return Object.assign({}, state, {crop_data: action.payload} )
    case 'UPDATE_IMAGE':
      return Object.assign({}, action.payload, {crop_data: {x: null, y: null, width: null, height: null}} )

    default:
      return state
  }
}

export default imageState
