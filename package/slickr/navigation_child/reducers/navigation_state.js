const navigationState = (state = {}, action) => {
  switch(action.type) {
    case 'CHOOSE_IMAGE':
      return Object.assign({}, state, {image: action.payload})
    default:
      return state
  }
}

export default navigationState
