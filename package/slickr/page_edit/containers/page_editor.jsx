// import draftToHtml from 'draftjs-to-html';
import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import PageWrapper from '../components/page_wrapper.jsx'
import * as PageActions from '../actions'

// import * as MainAppPageActions from 'slickr_extensions/page_edit/actions/additional_actions.js'

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

const MyEditor = ({schedulingActive, store, page, active_tab, actions, modalIsOpen, editorState}) => {
  return(
    <PageWrapper page={page} actions={actions} schedulingActive={schedulingActive} editorState={editorState} modalIsOpen={modalIsOpen} active_tab={active_tab} />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  editorState: PropTypes.object.isRequired,
}

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

// const mapDispatchToProps = dispatch => ({
//   actions: bindActionCreators(Object.assign({}, PageActions, MainAppPageActions), dispatch)
// })
const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(Object.assign({}, PageActions), dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(MyEditor);
