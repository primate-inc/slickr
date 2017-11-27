import { combineReducers } from 'redux'
import loadedImages from './loaded_images'
import selectedImages from './selected_images'

const rootReducer = combineReducers ({
  loadedImages,
  selectedImages
})

export default rootReducer
