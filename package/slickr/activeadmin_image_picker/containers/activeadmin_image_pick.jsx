import { editorStateToJSON } from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import ImageArea from "../components/image_area.jsx";
import ImageAreaMultiple from "../components/image_area_multiple.jsx";
import * as PageActions from '../../page_edit/actions';
import * as GalleryActions from '../../media_gallery/actions';

let _csrf_param = () => {
  return document.getElementsByName("csrf-param")[0].content
}
let _csrf_token = () => {
  return document.getElementsByName("csrf-token")[0].content
}

const ActiveadminImagePick = ({ store, actions, modalIsOpen, textAreaIndex,
                                label, textArea, page, loadedImages, newImageFieldId,
                                imageObject, choosingActiveAdminImage, tags,
                                allowedUploadInfo }) => {
  return(
    imageObject.multiple ?
    <ImageAreaMultiple actions={actions}
                       page={page}
                       modalIsOpen={modalIsOpen}
                       newImageFieldId={newImageFieldId}
                       textAreaIndex={textAreaIndex}
                       tags={tags}
                       label={label}
                       textArea={textArea}
                       loadedImages={loadedImages}
                       imageObject={imageObject}
                       choosingActiveAdminImage={choosingActiveAdminImage}
                       allowedUploadInfo={allowedUploadInfo}
    /> :
    <ImageArea actions={actions}
                      page={page}
                      modalIsOpen={modalIsOpen}
                      textAreaIndex={textAreaIndex}
                      tags={tags}
                      label={label}
                      textArea={textArea}
                      loadedImages={loadedImages}
                      imageObject={imageObject}
                      choosingActiveAdminImage={choosingActiveAdminImage}
                      allowedUploadInfo={allowedUploadInfo}
    />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  imageObject: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  choosingActiveAdminImage: PropTypes.bool.isRequired,
  allowedUploadInfo: PropTypes.object.isRequired
}

ActiveadminImagePick.propTypes = slickrPropTypes

const mapStateToProps = state => ({
  page: state.pageState,
  tags: state.tags,
  imageObject: state.imageObject,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  label: state.label,
  textArea: state.textArea,
  newImageFieldId: state.newImageFieldId,
  choosingActiveAdminImage: state.choosingActiveAdminImage,
  allowedUploadInfo: state.allowedUploadInfo
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(
    Object.assign({}, PageActions, GalleryActions), dispatch
  )
})

export default connect(mapStateToProps, mapDispatchToProps)(ActiveadminImagePick);
