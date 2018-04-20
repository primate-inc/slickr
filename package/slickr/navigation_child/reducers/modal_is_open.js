const modalIsOpen = (state = false, action) => {
  switch(action.type) {
    case 'TOGGLE_MODAL':
      return  state === true ? false : true
    default:
      return state
  }
}

export default modalIsOpen
