/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React, { Component } from "react";

import Dropdown from "../../components/Dropdown";
import {
  BlockActionGroup,
  BlockControls,
  BlockWrapper
} from "../../components/plugin";
import {
  DEFAULT_DISPLAY_OPTIONS,
  DEFAULT_DISPLAY_KEY
} from "../../components/plugin/defaults";

export default class CommonBlock extends Component {
  constructor(props) {
    super(props);

    this._handleDisplayChange = this._handleDisplayChange.bind(this);
  }

  _handleDisplayChange(newValue) {
    this.props.container.updateData({ display: newValue });
  }

  _areThereAdditionalOption = (additionalOption, data) => {
    return additionalOption.map((options) => {
      return (
        <Dropdown
          items={options.displayOptions}
          selected={data.display || options.defaultDisplay}
          onChange={this._handleDisplayChange}
        />
      );
    });
  };

  render() {
    const data = this.props.data;
    const defaults = {
      defaultDisplay: DEFAULT_DISPLAY_KEY,
      displayOptions: DEFAULT_DISPLAY_OPTIONS
    };
    let options = this.props.blockProps.plugin.options || {};
    console.log('options: ', options);
    options = { ...defaults, ...options };
    let additionalOption = this.props.blockProps.plugin.additionalOption || {};
    console.log('additionalOption: ', additionalOption);

    return (
      <BlockWrapper>
        <BlockControls>
          <Dropdown
            items={options.displayOptions}
            selected={data.display || options.defaultDisplay}
            onChange={this._handleDisplayChange}
          />
          { additionalOption ? this._areThereAdditionalOption(additionalOption, data) : null }

          <BlockActionGroup items={this.props.actions} />
        </BlockControls>

        {this.props.children}
      </BlockWrapper>
    );
  }
}
