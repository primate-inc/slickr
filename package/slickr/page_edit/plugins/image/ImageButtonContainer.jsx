import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as PageActions from '../../actions'
import * as MediaGalleryActions from '../../../media_gallery/actions';
import cx from 'classnames';
import ImageButton from "./ImageButton.jsx";

const ImageButtonContainer = ({
  modalIsOpen, actions, loadedImages, editorState, choosingPageHeaderImage,
  choosingNavImage, allowedUploadInfo, additionalInfo, tags
}) => (
  <div>
    <ImageButton modalIsOpen={modalIsOpen}
                 actions={actions}
                 tags={tags}
                 loadedImages={loadedImages}
                 editorState={editorState}
                 choosingPageHeaderImage={choosingPageHeaderImage}
                 choosingNavImage={choosingNavImage}
                 allowedUploadInfo={allowedUploadInfo}
                 additionalInfo={additionalInfo}
    />
  </div>
)

ImageButtonContainer.propTypes = {
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  allowedUploadInfo: PropTypes.object.isRequired,
  additionalInfo: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  active_tab: state.activeTab,
  tags: state.tags,
  modalIsOpen: state.modalIsOpen,
  tags: state.tags,
  loadedImages: state.loadedImages,
  editorState: state.editorState,
  choosingPageHeaderImage: state.choosingPageHeaderImage,
  choosingNavImage: state.choosingNavImage,
  allowedUploadInfo: state.allowedUploadInfo,
  additionalInfo: state.additionalInfo
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(
    Object.assign({}, PageActions, MediaGalleryActions), dispatch
  )
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ImageButtonContainer)
