import { combineReducers } from 'redux'
import navigationState from './navigation_state'
import modalIsOpen from './modal_is_open'
import loadedImages from './loaded_images'
import choosingImage from './choosing_image'

const rootReducer = combineReducers ({
  navigationState,
  modalIsOpen,
  loadedImages,
  choosingImage,
  childTypes: (state = []) => state
})

export default rootReducer
