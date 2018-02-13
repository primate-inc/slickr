import React, {Component} from "react";
import {insertDataBlock} from "megadraft";
import Icon from "./icon.jsx";
import Prompt from './Prompt.jsx';
import Popup from 'react-popup';

export default class VideoButton extends Component {

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
  }

  onClick(e) {
    e.preventDefault();
    let that = this
    
    Popup.plugins().prompt('', 'Paste Vimeo iframe', function (value) {
      const data = {iframe: value, type: "vimeo", display: "small"};
      that.props.onChange(insertDataBlock(that.props.editorState, data));
    });
  }

  shouldComponentUpdate() {
    return false
  }

  render() {
    return ([
      <button className={this.props.className} type="button" onClick={this.onClick} key='1'>
        <Icon className="sidemenu__button__icon" />
      </button>,
      <Popup key='2'/>
    ]);
  }
}

Popup.registerPlugin('prompt', function (defaultValue, placeholder, callback) {
  let promptValue = null;
  let promptChange = function (value) {
    promptValue = value;
  };

  this.create({
    content: <Prompt onChange={promptChange} placeholder={placeholder} value={defaultValue} />,
    buttons: {
      right: [{
        text: 'Embed',
        key: 'embed',
        className: 'success',
        action: function () {
          callback(promptValue);
          Popup.close();
        }
      }]
    }
  });
});
