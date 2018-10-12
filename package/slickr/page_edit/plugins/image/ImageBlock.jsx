import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
const {BlockContent,
  // CommonBlock,
  BlockData, BlockInput} = MegadraftPlugin;
import CommonBlock from "../../../text_area_editor/components/plugin/CommonBlock"
import icons from "megadraft/lib/icons";
import ImageBlockStyle from "./ImageBlockStyle.jsx";
import {
  DEFAULT_DISPLAY_OPTIONS,
  DEFAULT_DISPLAY_KEY
} from "../../../text_area_editor/components/plugin/defaults";

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
    console.log('MegadraftIcons: ', MegadraftIcons);
    const defaults = {
      defaultDisplay: DEFAULT_DISPLAY_KEY,
      displayOptions: DEFAULT_DISPLAY_OPTIONS
    };
    const additionalOption = {
      ...defaults,
      displayOptions: [
        {"key": "thumb_limit", "icon": MegadraftIcons.MediaSmallIcon, "label": "THUMBNAIL"},
        {"key": "s_limit", "icon": MegadraftIcons.MediaSmallIcon, "label": "SMALL"},
        {"key": "m_limit", "icon": MegadraftIcons.MediaMediumIcon, "label": "MEDIUM"},
        {"key": "l_limit", "icon": MegadraftIcons.MediaBigIcon, "label": "LARGE"},
        {"key": "xl_limit", "icon": MegadraftIcons.MediaBigIcon, "label": "EXTRA LARGE"},
        {"key": "full", "icon": MegadraftIcons.MediaBigIcon, "label": "FULL"}
      ],
      defaultDisplay: 'full'
    };

    return (
      <CommonBlock {...this.props} additionalOption={additionalOption} actions={this.actions}>
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
