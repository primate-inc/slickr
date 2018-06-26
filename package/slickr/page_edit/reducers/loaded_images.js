const loadedImages = (state = {}, action) => {
  switch(action.type) {
    case 'LOAD_IMAGES':
      return  action.payload
    case 'CANCEL_LOADER':
      return Object.assign({}, state, { loading: false })
    case 'SHOW_LOADER':
      return Object.assign({}, state, { loading: true })
    case 'ADD_UPLOAD':
      var newArray = state.images.slice();
      newArray.unshift(action.payload);
      return Object.assign({}, state, { images: newArray })
    case 'UPDATE_UPLOAD_PROGRESS':
      return Object.assign({}, state, { images: action.payload })
    case 'UPDATE_UPLOAD_STATE':
      return Object.assign({}, state, { images: action.payload })
    case 'ADD_TO_LOADED_IMAGES':
      var img = state.images[state.images.findIndex(
        x => x.id == action.payload.id
      )];
      var newArray = state.images.slice();
      newArray.splice(newArray.findIndex(x => x.id == action.payload.id), 1);
      newArray.unshift(action.payload.body);
      return Object.assign({}, state, { images: newArray })
    default:
      return state
  }
}

export default loadedImages
