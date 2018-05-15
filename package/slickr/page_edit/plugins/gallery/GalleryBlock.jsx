import React, {Component} from "react";
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
import GalleryImage from "./GalleryImage.jsx";
import ModalToOpen from '../image/ModalToOpen.jsx';

const {BlockContent, CommonBlock} = MegadraftPlugin;


export default class GalleryBlock extends Component {
  constructor(props) {
    super(props);

    this.updateGallery = this.updateGallery.bind(this);
    this.removeGallery = this.removeGallery.bind(this);

    this.actions = [
      {
        "key": "delete",
        "icon": MegadraftIcons.DeleteIcon,
        "action": this.props.container.remove
      }
    ];

    this.state = {
      pickingImage: false
    }
  }

  handleAddImage(value, image) {
    this.props.container.updateData(
      {gallery_items: this.props.data.gallery_items.concat({
        key: DraftJS.genKey(),
        type: value,
        image: image
      })}
    );
  }

  updateGallery(key, field, value) {
    for (let item of this.props.data.gallery_items) {
      if (item.key === key) {
        item[field] = value;
      }
    }
    this.props.container.updateData(
      {gallery_items: this.props.data.gallery_items}
    );
  }

  removeGallery(key) {
    let gallery_items = Array();
    for (let item of this.props.data.gallery_items) {
      if (item.key !== key) {
        gallery_items.push(item);
      }
    }
    this.props.container.updateData({gallery_items: gallery_items});
  }

  openImagePicker = () => (e) => {
    e.preventDefault();
    this.setState({pickingImage: true})
    const page = Object.keys(this.props.loadedImages).length === 0 ? 1 : (this.props.loadedImages.pagination_info.current_page + 1)
    this.props.actions.toggleChoosingGalleryImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.state.pickingImage && Object.keys(this.props.galleryImageToAdd).length !== 0) {
      this.setState({pickingImage: false})
      this.handleAddImage('image', this.props.galleryImageToAdd)
      this.props.actions.removeGalleryImage()
    }
  }

  render(){
    return (
      <div id="gallery_plugin_block">
        <CommonBlock {...this.props} actions={this.actions}>
          <BlockContent className="with-padding">
            {this.props.data.gallery_items.map((item) => {
              if(item.type === 'image') {
                return (
                  <GalleryImage
                    key={item.key}
                    item={item}
                    updateGallery={this.updateGallery}
                    removeGallery={this.removeGallery}
                    {...this.props} />
                );
              }
            })}
            <div className="gallery__add-new-wrapper">
              <a href="#"
                onClick={this.openImagePicker()}
                className="gallery__add-new">
                Add image to gallery
              </a>
            </div>
          </BlockContent>
        </CommonBlock>
        <ModalToOpen
          modalIsOpen={this.props.modalIsOpen}
          actions={this.props.actions}
          loadedImages={this.props.loadedImages}
          editorState={this.props.editorState}
          choosingGalleryImage={this.props.choosingGalleryImage}
        />
      </div>
    );
  }
}
