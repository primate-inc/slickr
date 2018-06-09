import React from 'react';
import { render } from 'react-dom';
import PropTypes from 'prop-types';
import Gallery from 'react-grid-gallery';
import {insertDataBlock} from "megadraft";
import galleryImages from '../../../utils/gallery_images.jsx'

export default class Grid extends React.Component {
  constructor(props){
    super(props);

    this.onClickThumbnail = this.onClickThumbnail.bind(this);
  }

  onClickThumbnail(index, event) {
    var data = {
      type: "image",
      image: {
        'id': this.props.images[index].id,
        'image_data': this.props.images[index].build_for_gallery,
        'additional_info': this.props.images[index].additional_info
      }
    };
    if(this.props.choosingPageHeaderImage) {
      this.props.actions.toggleChoosingPageHeaderImage();
      this.props.actions.updatePageHeaderImage(
        { id: data.image.id, path: data.image.image_data.display_size }
      )
    } else if(this.props.choosingNavImage) {
      this.props.actions.toggleChoosingImage();
      this.props.actions.updateNavImage(
        { id: data.image.id, path: data.image.image_data.url }
      )
    } else if(this.props.choosingGalleryImage) {
      this.props.actions.toggleChoosingGalleryImage();
      let urlParts = data.image.image_data.url.split('/uploads/').filter(String);
      if(urlParts.length === 2 && urlParts[0].indexOf('http') >= 0) {
        const domain = urlParts[0].substring(0, urlParts[0].lastIndexOf('/'));
        urlParts = { id: data.image.id, domain: domain, path: urlParts[1]  }
      } else {
        urlParts = { id: data.image.id, path: urlParts[1]  }
      }
      this.props.actions.addGalleryImage(urlParts)
    } else {
      this.props.actions.changeEditorState(insertDataBlock(this.props.editorState, data))
    }
    this.props.actions.toggleImagePicker()
  }

  render () {
    var images = galleryImages(this.props.images)

    return (
      <div>
        <Gallery
          images={images.map(function(a) {return a.build_for_gallery})}
          enableImageSelection={false}
          onClickThumbnail={this.onClickThumbnail}
          lightboxWidth={1536}
        />
      </div>
    );
  }
}

const customTagStyle = {
  wordWrap: "break-word",
  display: "inline-block",
  backgroundColor: "white",
  height: "auto",
  fontSize: "75%",
  fontWeight: "600",
  lineHeight: "1",
  padding: ".2em .6em .3em",
  borderRadius: ".25em",
  color: "black",
  verticalAlign: "baseline",
  margin: "2px"
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
