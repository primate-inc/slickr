import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import TextArea from '../components/text_area.jsx'
import * as MegadraftActions from '../../page_edit/actions'
import * as MainAppPageActions from 'slickr_extensions/page_edit/actions/additional_actions.js'

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

const MyTextAreaEditor = ({store, actions, modalIsOpen, page, editorState, pageState, textAreaIndex, label, textArea}) => {
  return(
    <TextArea actions={actions}
              page={page}
              editorState={editorState}
              modalIsOpen={modalIsOpen}
              textAreaIndex={textAreaIndex}
              label={label}
              textArea={textArea}
    />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.array.isRequired,
  editorState: PropTypes.object.isRequired,
}

MyTextAreaEditor.propTypes = slickrPropTypes

const mapStateToProps = state => ({
  page: state.pageState,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  loadedBooks: state.loadedBooks,
  loadedAuthors: state.loadedAuthors,
  editorState: state.editorState,
  textAreaIndex: state.textAreaIndex,
  label: state.label,
  textArea: state.textArea
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(Object.assign({}, MegadraftActions, MainAppPageActions), dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(MyTextAreaEditor);
