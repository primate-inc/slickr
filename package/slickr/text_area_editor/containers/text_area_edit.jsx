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

const MyTextAreaEditor = ({
  store, actions, modalIsOpen, page, editorState, pageState, textAreaIndex,
  label, labelText, textArea, allowedUploadInfo, additionalInfo, tags
}) => {
  return(
    <TextArea actions={actions}
              page={page}
              editorState={editorState}
              modalIsOpen={modalIsOpen}
              textAreaIndex={textAreaIndex}
              label={label}
              tags={tags}
              labelText={labelText}
              textArea={textArea}
              allowedUploadInfo={allowedUploadInfo}
              additionalInfo={additionalInfo}
    />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  editorState: PropTypes.object.isRequired,
  allowedUploadInfo: PropTypes.object.isRequired,
  additionalInfo: PropTypes.object.isRequired
}

MyTextAreaEditor.propTypes = slickrPropTypes

const mapStateToProps = state => ({
  page: state.pageState,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  editorState: state.editorState,
  textAreaIndex: state.textAreaIndex,
  label: state.label,
  tags: state.tags,
  labelText: state.labelText,
  textArea: state.textArea,
  allowedUploadInfo: state.allowedUploadInfo,
  additionalInfo: state.additionalInfo
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(Object.assign({}, MegadraftActions, MainAppPageActions), dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(MyTextAreaEditor);
