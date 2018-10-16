/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React, { Component } from "react";
import PropTypes from "prop-types";
import cx from "classnames";

export default class DropdownItem extends Component {
  static propTypes = {
    item: PropTypes.object.isRequired,
    style: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
    onClick: PropTypes.func
  };

  render() {
    const item = this.props.item;
    const Icon = item.icon;
    const containerClasses = cx({"dropdown__item ": true, [this.props.className]: true});
    const iconClasses = cx({
      "dropdown__item__icon": true,
      [item.classname]: item.classname ? true : false
    });
    console.log(this.props.item);

    return (
      <div
        className={containerClasses}
        onClick={this.props.onClick}
        onMouseDown={this.props.onMouseDown}
        onMouseUp={this.props.onMouseDown}
      >
        <Icon className={iconClasses} />
        <span className="dropdown__item__text">{this.props.item.label}</span>

        {this.props.children}
      </div>
    );
  }
}