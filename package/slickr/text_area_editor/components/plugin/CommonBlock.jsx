/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React, { Component } from "react";

import Dropdown from "../Dropdown";
import DropdownMkII from "../DropdownMkII";
import BlockActionGroup from "../plugin/BlockActionGroup";
import BlockControls from "../plugin/BlockControls";
import BlockWrapper from "../plugin/BlockWrapper";
import {
  DEFAULT_DISPLAY_OPTIONS,
  DEFAULT_DISPLAY_KEY
} from "./defaults";

export default class CommonBlock extends Component {
  constructor(props) {
    super(props);

    // this._handleDisplayChange = this._handleDisplayChange.bind(this);
  }

  // _handleDisplayChange(newValue) {
  //   this.props.container.updateData({ display: newValue, display2: newValue });
  // }

  _additionalOption = (additionalOption, data) => {
    // return additionalOption.map(() => {
      // console.log('options: ', options);
      const options = additionalOption;

      return (
        <Dropdown
          items={additionalOption.displayOptions}
          selected={data.display || additionalOption.defaultDisplay}
          // onChange={this._handleDisplayChange}
        />
      );
    // });
  };

  render() {
    const data = this.props.data;
    const defaults = {
      defaultDisplay: DEFAULT_DISPLAY_KEY,
      displayOptions: DEFAULT_DISPLAY_OPTIONS
    };
    let options = this.props.blockProps.plugin.options || {};
    options = { ...defaults, ...options };
    console.log('CB props: ', this.props);
    let additionalOption = this.props.additionalOption || {};
    console.log('additionalOption: ', additionalOption);

    return (
      <BlockWrapper>
        <BlockControls>
          <div style={{display: 'flex'}}>
            <div
              style={{color: 'orange', padding: '0px 100px'}}
            >
              <Dropdown
                key='1'
                container={this.props.container}
                items={options.displayOptions}
                selected={data.display || options.defaultDisplay}
                // onChange={this._handleDisplayChange}
              />
            </div>
            {/* { additionalOption ? this._additionalOption(additionalOption, data) : null } */}

            <div
              style={{color: 'pink', padding: '0px 100px'}}
            >
              <DropdownMkII
                key='2'
                container={this.props.container}
                items={additionalOption.displayOptions}
                selected={data.appearance || additionalOption.defaultDisplay}
                // onChange={this._handleDisplayChange}
              />
            </div>
          </div>
          <BlockActionGroup items={this.props.actions} />
        </BlockControls>

        {this.props.children}
      </BlockWrapper>
    );
  }
}
