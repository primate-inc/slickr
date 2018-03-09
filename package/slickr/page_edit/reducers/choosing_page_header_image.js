const choosingPageHeaderImage = (state = false, action) => {
  switch(action.type) {
    case 'TOGGLE_CHOOSING_PAGE_HEADER_IMAGE':
      return  state === true ? false : true
    default:
      return state
  }
}

export default choosingPageHeaderImage
