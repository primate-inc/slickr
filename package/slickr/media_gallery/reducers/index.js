import { combineReducers } from 'redux'
import loadedImages from './loaded_images'
import selectedImages from './selected_images'

const rootReducer = combineReducers ({
  loadedImages,
  selectedImages,
  allowedUploadInfo: (state = {}) => state
})

export default rootReducer
