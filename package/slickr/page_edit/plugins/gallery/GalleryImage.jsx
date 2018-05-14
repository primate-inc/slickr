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
    if(this.props.item.image) {
      return <img src={this.props.item.image} />
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
