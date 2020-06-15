const loadedPdfs = (state = {}, action) => {
  switch(action.type) {
    case 'LOAD_PDFS':
      return  action.payload

    default:
      return state
  }
}

export default loadedPdfs
