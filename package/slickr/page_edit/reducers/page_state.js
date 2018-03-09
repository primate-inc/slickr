const pageState = (state = {}, action) => {
  switch(action.type) {
    case "UNSCHEDULE":
      return Object.assign({}, state, { publishing_scheduled_for: null })
    case "SAVE_SCHEDULE":
      return Object.assign({}, state, { publishing_scheduled_for: action.payload, aasm_state: 'draft' })
    case 'SET_PAGE_TITLE':
      return Object.assign({},state, { title: action.title, layout: action.layout })
    case 'PUBLISH_PAGE':
      return Object.assign({}, state, {aasm_state: action.aasm_state, publishing_scheduled_for: null})
    case 'UNPUBLISH_PAGE':
      return Object.assign({}, state, {aasm_state: action.aasm_state})
    case 'CHOOSE_PAGE_HEADER_IMAGE':
      return Object.assign({}, state, {page_header_image: action.payload})
    default:
      return state
  }
}

export default pageState
