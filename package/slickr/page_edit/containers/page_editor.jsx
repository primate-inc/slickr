// import draftToHtml from 'draftjs-to-html';
import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import PageWrapper from '../components/page_wrapper.jsx'
import * as PageActions from '../actions'
import * as MainAppPageActions from 'slickr_extensions/page_edit/actions/additional_actions.js'

// import mainAppPropTypes from 'slickr_extensions/page_edit/containers/additional_prop_types.js'

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

// const submitPreview = (page, editorState) => {
//
//   const form = document.createElement("form");
//   form.setAttribute('action', page.admin_preview_page_path)
//   form.setAttribute('method', "POST")
//   form.setAttribute('target', "_blank")
//   form.style.display = 'none';
//   const content = editorStateToJSON(editorState)
//   document.body.appendChild(form);
//   const data = {
//     title: page.title,
//     page_intro: page.page_intro,
//     content: draftToHtml(JSON.parse(content))
//   }
//   const input = document.createElement("textarea");
//   input.name = 'page'
//   input.value = JSON.stringify(data)
//   const csrf_input = document.createElement('input')
//   csrf_input.type = 'hidden'
//   csrf_input.name = _csrf_param()
//   csrf_input.value = _csrf_token()
//   form.appendChild(input);
//   form.appendChild(csrf_input);
//   form.submit();
//   document.body.removeChild(form);
// }

const MyEditor = ({schedulingActive, store, page, active_tab, actions, modalIsOpen, editorState}) => {
  return(
    <PageWrapper page={page} actions={actions} schedulingActive={schedulingActive} editorState={editorState} modalIsOpen={modalIsOpen} active_tab={active_tab} />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.array.isRequired,
  editorState: PropTypes.object.isRequired,
}

// const mergedPropTypes = Object.assign(slickrPropTypes, mainAppPropTypes);

// MyEditor.propTypes = mergedPropTypes
MyEditor.propTypes = slickrPropTypes

const mapStateToProps = state => ({
  page: state.pageState,
  active_tab: state.activeTab,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  schedulingActive: state.schedulingActive,
  loadedBooks: state.loadedBooks,
  loadedAuthors: state.loadedAuthors,
  editorState: state.editorState
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(Object.assign({}, PageActions, MainAppPageActions), dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(MyEditor);
