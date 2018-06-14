/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React from "react";
import ReactDOM from 'react-dom';
import icons from "megadraft/lib/icons";
import ModalToOpen from './ModalToOpen.jsx';

export default class BlockButton extends React.Component {
  constructor(props) {
    super();

    this.openImagePicker = this.openImagePicker.bind(this);
  }

  openImagePicker () {
    const page = Object.keys(this.props.loadedImages).length === 0 ? 1 : this.props.loadedImages.pagination_info.current_page
    this.props.actions.toggleImagePicker();
    this.props.actions.loadImages(page);
  }

  render() {
    return (
      <div>
        <button className="sidemenu__button" type="button" onClick={this.openImagePicker} title="Image">
          <icons.ImageIcon className="sidemenu__button__icon" />
        </button>
        <ModalToOpen
          modalIsOpen={this.props.modalIsOpen}
          actions={this.props.actions}
          loadedImages={this.props.loadedImages}
          editorState={this.props.editorState}
          choosingPageHeaderImage={this.props.choosingPageHeaderImage}
          choosingNavImage={this.props.choosingNavImage}
        />
      </div>
    );
  }
}
