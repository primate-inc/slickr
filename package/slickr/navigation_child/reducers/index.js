import { combineReducers } from 'redux'
import navigationState from './navigation_state'
import modalIsOpen from './modal_is_open'
import loadedImages from './loaded_images'
import choosingNavImage from './choosing_nav_image'

const rootReducer = combineReducers ({
  navigationState,
  modalIsOpen,
  loadedImages,
  choosingNavImage,
  parent: (state = {}) => state,
  rootNav: (state = {}) => state,
  childTypes: (state = []) => state,
  selectablePages: (state = []) => state,
  allowedUploadInfo: (state = {}) => state
})

export default rootReducer
