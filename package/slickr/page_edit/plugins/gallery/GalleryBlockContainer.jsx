import React, {Component} from "react";
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as PageActions from '../../actions'
import cx from 'classnames';
import GalleryBlock from "./GalleryBlock.jsx";

class GalleryBlockContainer  extends Component {
  render() {
    return (
      <div>
        <GalleryBlock modalIsOpen={this.props.modalIsOpen}
                      actions={this.props.actions}
                      loadedImages={this.props.loadedImages}
                      editorState={this.props.editorState}
                      choosingGalleryImage={this.props.choosingGalleryImage}
                      blockProps={this.props.blockProps}
                      container={this.props.container}
                      data={this.props.data}
                      galleryImageToAdd={this.props.galleryImageToAdd}
        />
      </div>
    )
  }
}

function mapStateToProps(state, ownProps) {
  return {
    active_tab: state.activeTab,
    modalIsOpen: state.modalIsOpen,
    loadedImages: state.loadedImages,
    editorState: state.editorState,
    choosingGalleryImage: state.choosingGalleryImage,
    galleryImageToAdd: state.galleryImageToAdd
  }
}

function mapDispatchToProps(dispatch) {
  return {actions: bindActionCreators(PageActions, dispatch)}
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(GalleryBlockContainer)
