import React from 'react';
import { render } from 'react-dom';
import PropTypes from 'prop-types';
import Gallery from 'react-grid-gallery';
import galleryImages from '../../utils/gallery_images.jsx'

export default class Grid extends React.Component {
  constructor(props){
    super(props);

    this.onSelectImage = this.onSelectImage.bind(this);
  }

  onSelectImage (index, image) {
    if(image.isSelected === false) {
      this.props.actions.addSelectedImage(image)
    } else {
      this.props.actions.removeSelectedImage(image.id)
    }

    this.props.actions.toggleIsSelected(image.id)
  }

  render () {
    var images = galleryImages(this.props.images)

    return (
      <div id='image_gallery_wrapper'>
        <Gallery
          images={images.map(function(i) {return i.build_for_gallery})}
          onSelectImage={this.onSelectImage}
          lightboxWidth={1536}
        />
      </div>
    );
  }
}

const customTagStyle = {
  wordWrap: 'break-word',
  display: 'inline-block',
  backgroundColor: 'white',
  height: 'auto',
  fontSize: '75%',
  fontWeight: '600',
  lineHeight: '1',
  padding: '.2em .6em .3em',
  borderRadius: '.25em',
  color: 'black',
  verticalAlign: 'baseline',
  margin: '2px'
};

Grid.propTypes = {
  images: PropTypes.arrayOf(
    PropTypes.shape({
      build_for_gallery: PropTypes.shape({
        id: PropTypes.number.isRequired,
        src: PropTypes.string.isRequired,
        thumbnail: PropTypes.string.isRequired,
        srcset: PropTypes.array,
        caption: PropTypes.string.isRequired,
        thumbnailWidth: PropTypes.number.isRequired,
        thumbnailHeight: PropTypes.number.isRequired,
        isSelected: PropTypes.bool.isRequired,
        editPath: PropTypes.string.isRequired
      })
    })
  ).isRequired
};
