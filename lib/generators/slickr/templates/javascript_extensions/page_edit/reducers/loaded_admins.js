const loadedAdmins = (state = [], action) => {
  switch(action.type) {
    case 'LOAD_ADMINS':
      return  action.payload

    default:
      return state
  }
}

export default loadedAdmins
