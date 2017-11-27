/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React from "react";
import ReactDOM from 'react-dom';
import icons from "megadraft/lib/icons";
import ImagePickerModal from '../../components/content/image_picker_modal.jsx';

export default class BlockButton extends React.Component {
  constructor(props) {
    super();

    this.openImagePicker = this.openImagePicker.bind(this);
  }

  openImagePicker () {
    this.props.actions.toggleImagePicker();
    this.props.actions.loadImages();
  }

  render() {
    return (
      <div>
        <button className="sidemenu__button" type="button" onClick={this.openImagePicker} title="Image Gallery">
          <icons.ImageIcon className="sidemenu__button__icon" />
        </button>
        <ImagePickerModal
          modalIsOpen={this.props.modalIsOpen}
          actions={this.props.actions}
          loadedImages={this.props.loadedImages}
          editorState={this.props.editorState}
        />
      </div>
    );
  }
}
