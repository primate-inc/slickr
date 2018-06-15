import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as PageActions from '../../actions'
import * as MediaGalleryActions from '../../../media_gallery/actions';
import cx from 'classnames';
import ImageButton from "./ImageButton.jsx";

const ImageButtonContainer = ({modalIsOpen, actions, loadedImages, editorState, choosingPageHeaderImage, choosingNavImage}) => (
  <div>
    <ImageButton modalIsOpen={modalIsOpen}
                 actions={actions}
                 loadedImages={loadedImages}
                 editorState={editorState}
                 choosingPageHeaderImage={choosingPageHeaderImage}
                 choosingNavImage={choosingNavImage}
    />
  </div>
)

ImageButtonContainer.propTypes = {
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  active_tab: state.activeTab,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  editorState: state.editorState,
  choosingPageHeaderImage: state.choosingPageHeaderImage,
  choosingNavImage: state.choosingNavImage
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
