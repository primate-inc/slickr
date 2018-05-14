import React, {Component} from "react";
import {DraftJS, insertDataBlock} from "megadraft";

import Icon from "./icon.jsx";
import constants from "./constants";


export default class Button extends Component {
  constructor(props) {
    super(props);
    this.onClick = this.onClick.bind(this);
  }

  onClick(e) {
    const data = {gallery_items: [], type: constants.PLUGIN_TYPE};
    this.props.onChange(insertDataBlock(this.props.editorState, data));
  }

  render() {
    return (
      <button className={this.props.className} type="button" onClick={this.onClick} title={this.props.title}>
        <Icon className="sidemenu__button__icon" />
      </button>
    );
  }
}
