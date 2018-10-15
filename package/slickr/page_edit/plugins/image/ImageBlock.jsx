import React from 'react';
import ReactDOM from 'react-dom';
import { MegadraftPlugin, MegadraftIcons, DraftJS } from "megadraft";
const { BlockContent,
  // CommonBlock,
  BlockData, BlockInput } = MegadraftPlugin;
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

    const defaults = {
      defaultDisplay: DEFAULT_DISPLAY_KEY,
      displayOptions: DEFAULT_DISPLAY_OPTIONS
    };
    const layoutOptions = {
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
    }
    const appearanceOptions = {
      ...defaults,
      displayOptions: [
        {"key": "right", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT RIGHT"},
        {"key": "left", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT LEFT"},
        {"key": "center", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT CENTER"}
      ],
      defaultDisplay: 'center'
    };
    const behaviourOptions = {
      ...defaults,
      optionType: 'Transition',
      defaultDisplay: 'none',
      displayOptions: [
        {"key": "none", "icon": MegadraftIcons.MediaSmallIcon, "label": "NONE"},
        {"key": "width 2s", "icon": MegadraftIcons.MediaSmallIcon, "label": "TRANSITION", speedOptions: [] },
        {"key": "center", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT CENTER", speedOptions: []},
      ]
    };

    const appearance = this.props.data.appearance ? this.props.data.appearance : 'center'
    const transition = this.props.data.transition ? this.props.data.transition : 'none'
    let behaviour = { textAlign: appearance }
    // , transition: transition
    // -webkit-transition: width 2s; /* Safari */
    // transition: width 2s;

    const newStyle = { image:{ backgroundColor: 'pink', margin: '10px', padding: '16px' } }
    const styles = {...ImageBlockStyle.image, ...newStyle.image }

    return (
      <CommonBlock {...this.props}
        layoutOptions={layoutOptions}
        appearanceOptions={appearanceOptions}
        behaviourOptions={behaviourOptions}
        actions={this.actions}
      >
        <BlockContent>
          <div
            style={behaviour}
          >
            <img style={styles}
                src={`${this.props.data.image.media_upload_helper_path}?id=${this.props.data.image.id}`}
                alt={this.props.data.image.additional_info.alt_text}
            />
          </div>
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
