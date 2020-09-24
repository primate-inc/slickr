const newImageFieldId = (state = {}, action) => {
  switch(action.type) {
    case 'UPDATE_NEW_IMAGE_FIELD_ID':
      return action.payload
    default:
      return state
  }
}

export default newImageFieldId
