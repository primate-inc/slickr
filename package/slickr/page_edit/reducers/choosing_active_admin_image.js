const choosingActiveAdminImage = (state = false, action) => {
  switch(action.type) {
    case 'TOGGLE_CHOOSING_ACTIVEADMIN_IMAGE':
      return  state === true ? false : true
    default:
      return state
  }
}

export default choosingActiveAdminImage
