import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as PageActions from '../../actions'
import cx from 'classnames';
import ImageButton from "./ImageButton.jsx";

const ImageButtonContainer = ({modalIsOpen, actions, loadedImages, editorState, choosingPageHeaderImage}) => (
  <div>
    <ImageButton modalIsOpen={modalIsOpen}
                 actions={actions}
                 loadedImages={loadedImages}
                 editorState={editorState}
                 choosingPageHeaderImage={choosingPageHeaderImage}
    />
  </div>
)

ImageButtonContainer.propTypes = {
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  editorState: PropTypes.object.isRequired,
  choosingPageHeaderImage: PropTypes.bool.isRequired
}

const mapStateToProps = state => ({
  active_tab: state.activeTab,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  editorState: state.editorState,
  choosingPageHeaderImage: state.choosingPageHeaderImage
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(PageActions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ImageButtonContainer)
