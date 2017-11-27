const loadedAuthors = (state = [], action) => {
  switch(action.type) {
    case 'LOAD_AUTHORS':
      return  action.payload

    default:
      return state
  }
}

export default loadedAuthors
