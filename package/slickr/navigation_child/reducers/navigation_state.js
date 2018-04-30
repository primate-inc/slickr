const navigationState = (state = {}, action) => {
  switch(action.type) {
    case 'CHOOSE_NAV_IMAGE':
      return Object.assign(
        {}, state, {
          slickr_image_path: action.payload.path,
          slickr_image_id: action.payload.id
        })
    default:
      return state
  }
}

export default navigationState
