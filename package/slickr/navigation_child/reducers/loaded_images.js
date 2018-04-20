const loadedImages = (state = [], action) => {
  switch(action.type) {
    case 'LOAD_IMAGES':
      return  action.payload
    case 'CANCEL_LOADER':
      return Object.assign({}, state, { loading: false })
    case 'SHOW_LOADER':
      return Object.assign({}, state, { loading: true })
    case 'KEEP_CURRENT_PAGE':
      let page = state.pagination_info.current_page - 1
      let paginactionInfo = Object.assign({}, state.pagination_info, { current_page: page })
      return Object.assign({}, state, { pagination_info: paginactionInfo })

    default:
      return state
  }
}

export default loadedImages
