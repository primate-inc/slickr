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

  _submitAdditionalInfo = () => {
    // id: values.id,
    // additional_info: {
    //   alt_text: values.alt_text,
    //   img_title: values.img_title,
    //   img_credit: values.img_credit
    // }
  }


  // _loadDownloads = (downloadString, textAreaStoreIndex) => {
  //   let params = {};
  //   params[_csrf_param()] = _csrf_token()
  //   params["download_string"] = downloadString;

  //   request.get(text_editor_store[textAreaStoreIndex]
  //     .getState().pageState.admin_search_downloads_path)
  //     .set('Accept', 'json').query(params).end(function(err,resp){
  //     if(err) {
  //       console.error(err)
  //     } else {
  //       text_editor_store[textAreaStoreIndex].dispatch({
  //         type: 'LOAD_DOWNLOADS',
  //         payload: resp.body
  //       })
  //     }
  //   })

  //   this.props.container.onChange('load_downloads')

  //   this.loadData(textAreaStoreIndex).then(() => {
  //     let downloads = text_editor_store[textAreaStoreIndex].getState().loadedDownloads
  //     this.setState({
  //       loadedDownloads: downloads,
  //       loading: false
  //     });
  //   });
  // }


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
        </BlockData>
      </CommonBlock>
    );
  }
}
