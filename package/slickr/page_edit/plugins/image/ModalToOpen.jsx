import React from "react";
import ReactDOM from 'react-dom';
import ImagePickerModal from '../../components/content/image_picker_modal.jsx';

export default class ModalToOpen extends React.Component {
  render() {
    return (
        <ImagePickerModal
          modalIsOpen={this.props.modalIsOpen}
          actions={this.props.actions}
          tags={this.props.tags}
          loadedImages={this.props.loadedImages}
          editorState={this.props.editorState}
          choosingPageHeaderImage={this.props.choosingPageHeaderImage}
          allowedUploadInfo={this.props.allowedUploadInfo}
          additionalInfo={this.props.additionalInfo}
        />
    );
  }
}
