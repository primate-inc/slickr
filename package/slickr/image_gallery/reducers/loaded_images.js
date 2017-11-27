const loadedImages = (state = [], action) => {
  switch(action.type) {
    case 'TOGGLE_IS_SELECTED':
      var img = state[state.findIndex(x => x.id == action.payload)];
      img.build_for_gallery.isSelected = img.build_for_gallery.isSelected ? false : true;
      return  state;
    case 'CLEAR_ALL_SELECTED':
      var newArray = state.slice();
      newArray.forEach(function(img) {
        if ((action.payload).includes(img.id)) {
          img.build_for_gallery.isSelected = false
        }
      });
      return newArray;
    case 'DELETE_SELECTED_IMAGES':
      return action.payload
    case 'ADD_UPLOAD':
      var newArray = state.slice();
      newArray.unshift(action.payload);
      return newArray;
    case 'UPDATE_UPLOAD_PROGRESS':
      return action.payload
    case 'UPDATE_UPLOAD_STATE':
      return action.payload
    case 'ADD_TO_LOADED_IMAGES':
      var img = state[state.findIndex(x => x.id == action.payload.id)];
      var newArray = state.slice();
      newArray.splice(newArray.findIndex(x => x.id == action.payload.id), 1);
      newArray.unshift(action.payload.body);
      return newArray;

    default:
      return state
  }
}

export default loadedImages
