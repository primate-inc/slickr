
const galleryImageToAdd = (state = '', action) => {
  switch(action.type) {
    case 'ADD_GALLERY_IMAGE':
      return action.payload;
    case 'REMOVE_GALLERY_IMAGE':
      return '';

    default:
      return state
  }
}

export default galleryImageToAdd
