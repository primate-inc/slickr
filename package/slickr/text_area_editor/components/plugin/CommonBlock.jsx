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
  }

  _dropDownBuilder = (props) => {
    const data = props.data;
    const defaults = {
      defaultDisplay: DEFAULT_DISPLAY_KEY,
      displayOptions: DEFAULT_DISPLAY_OPTIONS
    };
    let options = this.props.blockProps.plugin.options || {};
    options = { ...defaults, ...options };
    // console.log('CB props: ', this.props);
    let additionalOption = this.props.additionalOption || {};
    // console.log('additionalOption: ', additionalOption);

    // return additionalOption.map(() => {
      // console.log('options: ', options);

      if(additionalOption) {
        return (
          <div style={{display: "flex"}}>
            <div>
              <Dropdown
                items={options.displayOptions}
                selected={data.display || additionalOption.defaultDisplay}
              />
            </div>
            <div>
              <DropdownMkII
                container={this.props.container}
                items={additionalOption.displayOptions}
                selected={data.appearance || additionalOption.defaultDisplay}
              />
            </div>
          </div>
        );
      } else {
        return (
          <Dropdown
            items={options.displayOptions}
            selected={data.display || additionalOption.defaultDisplay}
          />
        );
      }

      // <div style={{display: 'flex'}}>
      //       <div
      //         style={{color: 'orange', padding: '0px 100px'}}
      //       >
      //         <Dropdown
      //           container={this.props.container}
      //           items={options.displayOptions}
      //           selected={data.display || options.defaultDisplay}
      //         />
      //       </div>
      //       {/* { additionalOption ? this._additionalOption(additionalOption, data) : null } */}

      //       {
      //         additionalOption ?
      //         <div style={{color: 'pink', padding: '0px 100px'}}>
      //           <DropdownMkII
      //             container={this.props.container}
      //             items={additionalOption.displayOptions}
      //             selected={data.appearance || additionalOption.defaultDisplay}
      //           />
      //         </div> :
      //         null
      //       }
      //     </div>
  };

  render() {
    return (
      <BlockWrapper>
        <BlockControls>
          { this._dropDownBuilder(this.props) }
          <BlockActionGroup items={this.props.actions} />
        </BlockControls>

        {this.props.children}
      </BlockWrapper>
    );
  }
}
