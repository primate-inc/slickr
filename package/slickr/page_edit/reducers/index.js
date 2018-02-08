import { combineReducers } from 'redux'
import pageState from './page_state'
import activeTab from './active_tab'
import modalIsOpen from './modal_is_open'
import loadedImages from './loaded_images'
import editorState from './editor_state'
import schedulingActive from './scheduling_active'
import mainAppReducers from 'slickr_extensions/page_edit/reducers/additional_reducers.js'

import textAreaIndex from './text_area_index'
import label from './label'
import textArea from './text_area'

const slickrReducers = {
  pageState,
  activeTab,
  modalIsOpen,
  loadedImages,
  schedulingActive,
  editorState,
  textAreaIndex,
  label,
  textArea
}

const mergedReducers = Object.assign(slickrReducers, mainAppReducers);

const rootReducer = combineReducers (mergedReducers)

export default rootReducer
