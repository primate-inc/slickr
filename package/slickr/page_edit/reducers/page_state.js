const pageState = (state = {}, action) => {
  switch(action.type) {
    case "UNSCHEDULE":
      return Object.assign({}, state, { publishing_scheduled_for: null })
    case "SAVE_SCHEDULE":
      return Object.assign({}, state, { publishing_scheduled_for: action.payload, aasm_state: 'draft' })
    case 'SET_PAGE_TITLE':
      return Object.assign({},state, { title: action.title, layout: action.layout })
    case 'SET_PAGE_HEADER_IMAGE':
      return Object.assign({},state, {
        slickr_image_id: action.slickr_image_id,
        slickr_image_path: action.slickr_image_path
      })
    case 'PUBLISH_PAGE':
      return Object.assign({}, state, {aasm_state: action.aasm_state, publishing_scheduled_for: null})
    case 'UNPUBLISH_PAGE':
      return Object.assign({}, state, {aasm_state: action.aasm_state})
    case 'CHOOSE_PAGE_HEADER_IMAGE':
    return Object.assign(
      {}, state, {
        slickr_image_path: action.payload.path,
        slickr_image_id: action.payload.id
      })
    default:
      return state
  }
}

export default pageState
