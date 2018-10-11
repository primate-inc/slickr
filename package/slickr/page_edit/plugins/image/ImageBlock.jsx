import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
const {BlockContent, 
  // CommonBlock, 
  BlockData, BlockInput} = MegadraftPlugin;
import CommonBlock from "../../../text_area_editor/components/CommonBlock"
import icons from "megadraft/lib/icons";
import ImageBlockStyle from "./ImageBlockStyle.jsx";

export default class ImageBlock extends React.Component {
  constructor(props) {
    super(props);

    this.handleCaptionChange = this.handleCaptionChange.bind(this);

    this.actions = [{
      "key": "delete",
      "icon": icons.DeleteIcon,
      "action": this.props.container.remove
    }];
  }

  handleCaptionChange(e) {
    e.stopPropagation();
    this.props.container.updateData({caption: e.target.value});
  }

  render(){
    return (
      <CommonBlock {...this.props} actions={this.actions}>
        <BlockContent>
          <img style={ImageBlockStyle.image}
               src={`${this.props.data.image.media_upload_helper_path}?id=${this.props.data.image.id}`}
               alt={this.props.data.image.additional_info.alt_text}
          />
        </BlockContent>
        {/*<BlockData>
          <BlockInput
            placeholder="Caption"
            value={this.props.data.caption}
            onChange={this.handleCaptionChange} />
        </BlockData>*/}
      </CommonBlock>
    );
  }
}
