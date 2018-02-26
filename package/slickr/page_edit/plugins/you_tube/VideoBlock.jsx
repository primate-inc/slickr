import React, {Component} from "react";
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
import VideoBlockStyle from "./VideoBlockStyle.js";
import ReactHtmlParser, { processNodes, convertNodeToElement, htmlparser2 } from 'react-html-parser';

const {BlockContent, BlockData, BlockInput, CommonBlock} = MegadraftPlugin;

export default class VideoBlock extends Component {
  constructor(props) {
    super(props);

    this.handleCaptionChange = this.handleCaptionChange.bind(this);

    this.actions = [
      {"key": "delete", "icon": MegadraftIcons.DeleteIcon, "action": this.props.container.remove}
    ];
  }

  handleCaptionChange(event) {
    this.props.container.updateData({caption: event.target.value});
  }

  render() {
    return (
      <CommonBlock {...this.props} actions={this.actions} >
        <BlockContent className="you_tube_block">
          {ReactHtmlParser(this.props.data.iframe)}
        </BlockContent>
        <BlockData>
          <BlockInput
            placeholder="Caption"
            value={this.props.data.caption}
            onChange={this.handleCaptionChange} />
        </BlockData>
      </CommonBlock>
    );
  }
}
