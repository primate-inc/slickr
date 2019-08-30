import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
const {BlockContent, CommonBlock, BlockData, BlockInput} = MegadraftPlugin;
import icons from "megadraft/lib/icons";
import ImageBlockStyle from "./ImageBlockStyle.jsx";

export default class ImageBlock extends React.Component {
  constructor(props) {
    super(props);

    this.handleCaptionChange = this.handleCaptionChange.bind(this);
    this.handleAltTextChange = this.handleAltTextChange.bind(this);
    this.handleCreditChange = this.handleCreditChange.bind(this);
    this.handleLinkChange = this.handleLinkChange.bind(this);

    this.actions = [{
      "key": "delete",
      "icon": icons.DeleteIcon,
      "action": this.props.container.remove
    }];
  }

  handleCaptionChange(e) {
    e.stopPropagation();
    const image = this.props.data.image
    image.additional_info.img_title = e.target.value
    this.props.container.updateData({ image: image });
  }

  handleAltTextChange(e) {
    e.stopPropagation();
    const image = this.props.data.image
    image.additional_info.alt_text = e.target.value
    this.props.container.updateData({ image: image });
  }

  handleCreditChange(e) {
    e.stopPropagation();
    const image = this.props.data.image
    image.additional_info.img_credit = e.target.value
    this.props.container.updateData({ image: image });
  }

  handleLinkChange(e) {
    e.stopPropagation();
    const image = this.props.data.image
    image.additional_info.img_link = e.target.value
    this.props.container.updateData({ image: image });
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
        <BlockData>
          <BlockInput
            placeholder="Alt text"
            value={this.props.data.image.additional_info.alt_text}
            onChange={this.handleAltTextChange} />
          <BlockInput
            placeholder="Caption"
            value={this.props.data.image.additional_info.img_title}
            onChange={this.handleCaptionChange} />
          <BlockInput
            placeholder="Credit"
            value={this.props.data.image.additional_info.img_credit}
            onChange={this.handleCreditChange} />
          <BlockInput
            placeholder="Image Link"
            value={this.props.data.image.additional_info.img_link}
            onChange={this.handleLinkChange} />
        </BlockData>
      </CommonBlock>
    );
  }
}


// import React from 'react';
// import ReactDOM from 'react-dom';
// import {MegadraftPlugin, MegadraftIcons, DraftJS} from "megadraft";
// const {BlockContent, CommonBlock, BlockData, BlockInput} = MegadraftPlugin;
// import icons from "megadraft/lib/icons";
// import ImageBlockStyle from "./ImageBlockStyle.jsx";

// export default class ImageBlock extends React.Component {
//   constructor(props) {
//     super(props);

//     this.handleCaptionChange = this.handleCaptionChange.bind(this);

//     this.actions = [{
//       "key": "delete",
//       "icon": icons.DeleteIcon,
//       "action": this.props.container.remove
//     }];
//   }

//   handleCaptionChange(e) {
//     e.stopPropagation();
//     this.props.container.updateData({caption: e.target.value});
//   }

//   render(){
//     return (
//       <CommonBlock {...this.props} actions={this.actions}>
//         <BlockContent>
//           <img style={ImageBlockStyle.image}
//                src={`${this.props.data.image.media_upload_helper_path}?id=${this.props.data.image.id}`}
//                alt={this.props.data.image.additional_info.alt_text}
//           />
//         </BlockContent>
//         {/*<BlockData>
//           <BlockInput
//             placeholder="Caption"
//             value={this.props.data.caption}
//             onChange={this.handleCaptionChange} />
//         </BlockData>*/}
//       </CommonBlock>
//     );
//   }
// }
