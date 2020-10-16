/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React, { Component } from "react";
import icons from "megadraft/lib/icons";

class CtaLinkInput extends Component {
  constructor(props) {
    super(props);
    this.state = {
      url: (props && props.url) || "",
      text: (props && props.childen) || ""
    };
    this.onLinkChange = this.onLinkChange.bind(this);
    this.onLinkKeyDown = this.onLinkKeyDown.bind(this);
  }

  setLink(event) {
    let { url } = this.state;

    this.props.setEntity({ url });

    this.reset();

    // Force blur to work around Firefox's NS_ERROR_FAILURE
    event.target.blur();
  }

  reset() {
    this.setState({
      url: ""
    });

    this.props.cancelEntity();
  }

  onLinkChange(event) {
    event.stopPropagation();
    const url = event.target.value;

    if (url === "") {
      this.props.cancelError();
    }

    this.setState({ url: url });
  }

  onLinkKeyDown(event) {
    if (event.key == "Enter") {
      event.preventDefault();
      this.setLink(event);
    } else if (event.key == "Escape") {
      event.preventDefault();
      this.reset();
    }
  }

  componentDidMount() {
    this.textInput.focus();
  }

  render() {
    const { i18n } = this.props;
    const msg = "Type the link and press enter";

    return (
      <div style={{ whiteSpace: "nowrap" }}>
        <input
          ref={el => {
            this.textInput = el;
          }}
          type="text"
          className="toolbar__input"
          onChange={this.onLinkChange}
          value={this.state.url}
          onKeyDown={this.onLinkKeyDown}
          placeholder={msg}
          style={{color: 'white'}}
        />
        <span className="toolbar__item" style={{ verticalAlign: "bottom" }}>
          <button
            onClick={this.props.removeEntity}
            type="button"
            className="toolbar__button toolbar__input-button"
          >
            {this.props.entity ? <icons.UnlinkIcon /> : <icons.CloseIcon />}
          </button>
        </span>
      </div>
    );
  }
}

export default CtaLinkInput;
