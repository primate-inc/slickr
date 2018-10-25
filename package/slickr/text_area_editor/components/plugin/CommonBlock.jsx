/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import React, { Component } from "react";

import Dropdown from "../DropdownMkI";
import DropdownMkII from "../DropdownMkII";
import DropdownMkIII from "../DropdownMkIII";
import BlockActionGroup from "../plugin/BlockActionGroup";
import BlockControls from "../plugin/BlockControls";
import BlockWrapper from "../plugin/BlockWrapper";

export default class CommonBlock extends Component {
  constructor(props) {
    super(props);
  }

  _dropDownBuilder = (props) => {
    const data = props.data;

    const layoutOptions = this.props.blockProps.plugin.layoutOptions || {"nope":"no layout options passed to CommonBlock"};
    const appearanceOptions = this.props.blockProps.plugin.appearanceOptions || {};
    const behaviourOptions = this.props.blockProps.plugin.behaviourOptions || {};


    if( behaviourOptions ) {
      return (
        <div style={{display: "flex"}}>
          <div>
            <Dropdown
              container={this.props.container}
              items={layoutOptions.displayOptions}
              selected={data.display || layoutOptions.defaultDisplay}
            />
          </div>
          <div>
            <DropdownMkII
              container={this.props.container}
              items={appearanceOptions.displayOptions}
              selected={data.appearance || appearanceOptions.defaultDisplay}
            />
          </div>
          <div>
            <DropdownMkIII
              container={this.props.container}
              items={behaviourOptions.displayOptions}
              selected={data.behaviour || behaviourOptions.defaultDisplay}
            />
          </div>
        </div>
      );
    } else if(appearanceOptions) {
      return (
        <div style={{display: "flex"}}>
          <div>
            <Dropdown
              container={this.props.container}
              items={layoutOptions.displayOptions}
              selected={data.display || layoutOptions.defaultDisplay}
            />
          </div>
          <div>
            <DropdownMkII
              container={this.props.container}
              items={appearanceOptions.displayOptions}
              selected={data.appearance || appearanceOptions.defaultDisplay}
            />
          </div>
        </div>
      );
    }else {
      return (
        <Dropdown
          container={this.props.container}
          items={layoutOptions.displayOptions}
          selected={data.display || layoutOptions.defaultDisplay}
        />
      );
    }
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
