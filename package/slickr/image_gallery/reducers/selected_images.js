const selectedImages = (state = [], action) => {
  switch(action.type) {
    case 'ADD_SELECTED_IMAGE':
      return  state.concat(action.payload)
    case 'REMOVE_SELECTED_IMAGE':
      var toDelete = new Set([action.payload]);
      return state.filter(obj => !toDelete.has(obj.id));
    case 'CLEAR_ALL_SELECTED':
      return []
    case 'DELETE_SELECTED_IMAGES':
      return []

    default:
      return state
  }
}

export default selectedImages
