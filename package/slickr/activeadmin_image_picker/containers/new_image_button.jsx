import { editorStateToJSON } from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import ImageButton from "../components/image_button.jsx";
import * as PageActions from '../../page_edit/actions';
import * as GalleryActions from '../../media_gallery/actions';

const NewImageButton = ({ actions, modalIsOpen, textAreaIndex, additionalInfo,
  newImageFieldId,
                          label, textArea, page, newObject, loadedImages,
                          imageObject, choosingActiveAdminImage, tags, hint,
                          allowedUploadInfo }) => {
  return(
    <ImageButton tags={tags}
                 label={label}
                 textArea={textArea}
                 choosingActiveAdminImage={choosingActiveAdminImage}
                 page={page}
                 actions={actions}
                 hint={hint}
                 newImageFieldId={newImageFieldId}
                 textAreaIndex={textAreaIndex}
                 loadedImages={loadedImages}
                 modalIsOpen={modalIsOpen}
                 newObject={newObject}
                 imageObject={imageObject}
                 allowedUploadInfo={allowedUploadInfo}
                 additionalInfo={additionalInfo} />
  )
}

const mapStateToProps = state => ({
  page: state.pageState,
  allowedUploadInfo: state.allowedUploadInfo,
  additionalInfo: state.additionalInfo,
  loadedImages: state.loadedImages,
  newImageFieldId: state.newImageFieldId,
  imageObject: state.imageObject,
  newObject: state.newObject,
  modalIsOpen: state.modalIsOpen,
  hint: state.hint,
  tags: state.tags,
  label: state.label,
  textArea: state.textArea,
  choosingActiveAdminImage: state.choosingActiveAdminImage,
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(
    Object.assign({}, PageActions, GalleryActions), dispatch
  )
})

export default connect(mapStateToProps, mapDispatchToProps)(NewImageButton);
