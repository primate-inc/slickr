const navigationState = (state = {}, action) => {
  switch(action.type) {
    case 'CHOOSE_NAV_IMAGE':
      return Object.assign({}, state, { navigation_image: action.payload })
    default:
      return state
  }
}

export default navigationState
