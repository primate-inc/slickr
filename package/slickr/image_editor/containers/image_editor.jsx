import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Cropper from '../components/cropper.jsx';
import ImageForm from '../components/image_form.jsx';
import React, { Component } from 'react';
import * as ImageActions from '../actions'


const ImageEditor = ({store, image, actions}) => (
    <div id='image_editor'>
      <Cropper actions={actions} image={image} />
      <ImageForm actions={actions} image={image} key={image.timestamped_image_url + JSON.stringify(image.crop_data)}/>
    </div>
  );

ImageEditor.propTypes = {
  image: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  image: state.imageState
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(ImageActions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ImageEditor)
