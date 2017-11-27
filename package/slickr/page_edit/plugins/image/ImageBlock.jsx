import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
const {BlockContent, CommonBlock, BlockData, BlockInput} = MegadraftPlugin;
import icons from "megadraft/lib/icons";
import ImageBlockStyle from "./ImageBlockStyle";

export default class ImageBlock extends React.Component {
  constructor(props) {
    super(props);

    this.actions = [
      {"key": "delete", "icon": icons.DeleteIcon, "action": this.props.container.remove}
    ];
  }

  render(){
    return (
      <CommonBlock {...this.props} actions={this.actions}>
        <BlockContent>
          <img style={ImageBlockStyle.image}
               src={this.props.data.image.attachment.small.url}
               alt={this.props.data.image.data.alt_text}
          />
        </BlockContent>
        {/* <BlockData>
          <BlockInput placeholder="Enter an image caption" />
        </BlockData>*/}
      </CommonBlock>
    );
  }
}
