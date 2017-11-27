const loadedImages = (state = [], action) => {
  switch(action.type) {
    case 'LOAD_IMAGES':
      return  action.payload

    default:
      return state
  }
}

export default loadedImages
