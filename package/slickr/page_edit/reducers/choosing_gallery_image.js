const choosingGalleryImage = (state = false, action) => {
  switch(action.type) {
    case 'TOGGLE_CHOOSING_GALLERY_IMAGE':
      return  state === true ? false : true
    default:
      return state
  }
}

export default choosingGalleryImage
