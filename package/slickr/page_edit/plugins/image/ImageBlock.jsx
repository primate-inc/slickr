import React from 'react';
import ReactDOM from 'react-dom';
import { MegadraftPlugin, MegadraftIcons, DraftJS } from "megadraft";
const { BlockContent,
  // CommonBlock, //Removed to add custom CommonBlock
  BlockData, BlockInput } = MegadraftPlugin;
import CommonBlock from "../../../text_area_editor/components/plugin/CommonBlock"
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
    const layout = this.props.data.classname ? this.props.data.classname : 'normal_img-layout'
    const appearance = this.props.data.appearance ? this.props.data.appearance : 'appearance-none'
    const behaviour = this.props.data.behaviour ? this.props.data.behaviour : 'normal-speed'
    const styles = appearance + ' ' + behaviour;
    console.log('<------- heellow from Slicker CommonBlock xoxo --------->');
    return (
      <CommonBlock {...this.props} actions={this.actions}>
        <BlockContent>
          <div className={layout}>
            <img
              className={styles}
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
