import React from 'react';
import ReactDOM from 'react-dom';
import ReactCrop from 'react-image-crop';

export default class Cropper extends React.Component {
  constructor() {
    super();
    this.state = {
      crop: {
        x: 0,
        y: 0,
      }
    };
  }

  onImageLoaded = (crop) => {
    this.setState({
      crop: {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      },
    });
    this.props.actions.updateCropData({x: null, y: null, width: null, height: null})
  }

  onCropComplete = (crop, pixelCrop) => {
    this.setState({ crop });
    if((pixelCrop.width === 0) && (pixelCrop.height === 0))
      this.props.actions.updateCropData({x: null, y: null, width: null, height: null})
    else
      this.props.actions.updateCropData(pixelCrop)
  }

  render() {
    return(
      <ReactCrop
        {...this.state}
        src={this.props.image.timestamped_image_url}
        onImageLoaded={this.onImageLoaded}
        onComplete={this.onCropComplete}
      />
    )
  }
}
