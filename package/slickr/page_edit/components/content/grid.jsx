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
    let megadraftImageData = {
      type: 'image',
      image: {
        'id': this.props.images[index].id,
        'slickr_upload_path': this.props.images[index].build_for_gallery.displayPath,
        'additional_info': this.props.images[index].additional_info,
        'media_upload_helper_path': '/admin/slickr_media_uploads/return_media_path',
        'mime_type': this.props.images[index].build_for_gallery.mimeType
      }
    };

    if(this.props.allowedUploadInfo.file_mime_types.indexOf(megadraftImageData.image.mime_type) === -1) {
      let standardImageData = {
        id: this.props.images[index].id,
        path: this.props.images[index].build_for_gallery.displayPath
      }

      if(this.props.choosingPageHeaderImage) {
        this.props.actions.toggleChoosingPageHeaderImage();
        this.props.actions.updatePageHeaderImage(standardImageData)
      } else if(this.props.choosingNavImage) {
        this.props.actions.toggleChoosingImage();
        this.props.actions.updateNavImage(standardImageData)
      } else if(this.props.choosingActiveAdminImage) {
        this.props.actions.toggleChoosingActiveAdminImage();
        this.props.actions.updateActiveAdminImage(standardImageData)
      } else {
        this.props.actions.changeEditorState(
          insertDataBlock(this.props.editorState, megadraftImageData)
        )
      }
      this.props.actions.toggleImagePicker()
    }
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
