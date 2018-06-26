import { combineReducers } from 'redux'
import pageState from './page_state'
import activeTab from './active_tab'
import modalIsOpen from './modal_is_open'
import loadedImages from './loaded_images'
import editorState from './editor_state'
import schedulingActive from './scheduling_active'
import mainAppReducers from 'slickr_extensions/page_edit/reducers/additional_reducers.js'
import choosingPageHeaderImage from './choosing_page_header_image'

import textAreaIndex from './text_area_index'
import label from './label'
import textArea from './text_area'
import imageObject from './image_object'
import choosingActiveAdminImage from './choosing_active_admin_image'

const slickrReducers = {
  pageState,
  activeTab,
  modalIsOpen,
  loadedImages,
  pageLayouts: (state = {}) => state,
  schedulingActive,
  editorState,
  textAreaIndex,
  label,
  textArea,
  imageObject,
  choosingActiveAdminImage,
  choosingPageHeaderImage
}

const mergedReducers = Object.assign(slickrReducers, mainAppReducers);

const rootReducer = combineReducers (mergedReducers)

export default rootReducer
