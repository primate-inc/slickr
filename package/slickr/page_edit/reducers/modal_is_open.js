const modalIsOpen = (state = false, action) => {
  switch(action.type) {
    case 'TOGGLE_MODAL':
      return  state === true ? false : true
    case 'ADD_IMAGE_TO_EDITOR_STATE':
      return false
    default:
      return state
  }
}

export default modalIsOpen
