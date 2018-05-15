import React, {Component} from "react";
import {MegadraftPlugin, MegadraftIcons} from "megadraft";
const {BlockInput} = MegadraftPlugin;
import classNames from "classnames";

export default class Date extends Component {

  handleTextChange = (value) => (e) => {
    this.props.updateGallery(this.props.item.key, value, e.target.value);
  }

  handleDeleteClick = () => (e) => {
    this.props.removeGallery(this.props.item.key);
  }

  imageContainer() {
    if(Object.keys(this.props.item.image).length !== 0) {
      let url;
      const image = this.props.item.image
      if(Object.keys(image).length === 3) {
        url = `${image.domain}/${process.env.NODE_ENV}/uploads/${image.path}`
      } else {
        url = `/${process.env.NODE_ENV}/uploads/${image.path}`
      }
      return <img src={url} />
    }
  }

  render() {
    let {value, error, styles, ...props} = this.props;
    styles = styles || {};

    let className = classNames({
      "block__input": true,
      "block__input--empty": !value,
      "block__input--error": error,
      [`block__input--${styles.padding}-padding`]: styles.padding,
      [`block__input--${styles.text}-text`]: styles.text
    });

    return (
      <div className="gallery">
        <div className="gallery__inputs">
          <BlockInput
            placeholder={"Caption"}
            value={this.props.item.caption}
            onChange={this.handleTextChange('caption')} />
          <div>{this.imageContainer()}</div>
        </div>
        <div className="gallery__trash" onClick={this.handleDeleteClick()}>
          <MegadraftIcons.DeleteIcon/>
        </div>
      </div>
    );
  }
}
