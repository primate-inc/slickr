const loadedBooks = (state = [], action) => {
  switch(action.type) {
    case 'LOAD_BOOKS':
      return  action.payload

    default:
      return state
  }
}

export default loadedBooks
