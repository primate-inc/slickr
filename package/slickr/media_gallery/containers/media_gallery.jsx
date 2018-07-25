import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import NewImage from '../components/new_image.jsx';
import Grid from '../components/grid.jsx';
import Buttons from '../components/buttons.jsx';
import React, { Component } from 'react';
import * as ImageActions from '../actions'

const MediaGallery = (
  { store, images, selectedImages, allowedUploadInfo, actions }
) => (
    <div>
      <Buttons selectedImages={selectedImages}
               actions={actions}
               allowedUploadInfo={allowedUploadInfo} />
      <NewImage actions={actions} allowedUploadInfo={allowedUploadInfo} />
      <Grid images={images} actions={actions} />
    </div>
  );

MediaGallery.propTypes = {
  images: PropTypes.array.isRequired,
  selectedImages: PropTypes.array.isRequired,
  allowedUploadInfo: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  images: state.loadedImages,
  selectedImages: state.selectedImages,
  allowedUploadInfo: state.allowedUploadInfo
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(ImageActions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(MediaGallery)
