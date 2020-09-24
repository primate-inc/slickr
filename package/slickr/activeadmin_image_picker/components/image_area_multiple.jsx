import React from 'react';
import ReactDOM from 'react-dom';
import ImagePickerModal from '../../page_edit/components/content/image_picker_modal.jsx';

export default class ImageAreaMultiple extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      slickr_media_upload_id: this.props.imageObject.id,
      slickr_media_upload_path: this.props.imageObject.path,
      textAreaId: this.props.textArea.id,
    }

  }

  componentDidUpdate(prevProps) {
    if(this.props.imageObject && (this.props.imageObject.id !== prevProps.imageObject.id) && (this.props.newImageFieldId == this.state.textAreaId)) {
      this.setState({
        slickr_media_upload_id: this.props.imageObject.id,
        slickr_media_upload_path: this.props.imageObject.path,
      })
    }
  }

  openImagePicker = () => (e) => {
    e.preventDefault();
    let page
    if(Object.keys(this.props.loadedImages).length === 0) {
      page = 1
    } else {
      page = this.props.loadedImages.pagination_info.current_page
    }
    this.props.actions.toggleChoosingActiveAdminImage();
    this.props.actions.toggleImagePicker();
    this.props.actions.updateNewImageFieldId(this.state.textAreaId);
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
  }

  removeImage(id, e) {
    e.preventDefault()
    this.props.actions.updateNewImageFieldId(id);
    this.setState({
      slickr_media_upload_id: 'nil',
      slickr_media_upload_path: null
    })
    this.props.actions.updateNewImageFieldId({ id: null, path: null })
  }

  render() {
    const actions = this.props.actions
    const textAreaName = this.props.textArea.name.match(/.*\[.*\]\[\d*\]/)
    const uploadIdName = textAreaName[0] + '[id]'
    const mediaIdName = textAreaName[0] + '[slickr_media_upload_id]'
    const error = this.props.imageObject.errors[0]

    let hint;
    if(this.props.imageObject.hint == '') {
      hint = ''
    } else {
      hint = ` (${this.props.imageObject.hint}) `
    }
    const imagePath = this.state.slickr_media_upload_path
    const mediaUploadId = this.state.slickr_media_upload_id

    const imageElement = mediaUploadId != null ?
      <div className="inline-hints">
        <img src={imagePath} />
        <div className={`image-picker-remove ${mediaUploadId == null ? 'no_image' : 'has_image'}`}>
          <div className="true_false image boolean input optional">
            <div className="edit-wrapper">
              <label onClick={this.removeImage.bind(this, this.props.textArea.id)} className='label_remove' htmlFor={`remove_${this.props.imageObject.field}`}>
                <input type="checkbox"
                       name={`remove_${this.props.imageObject.field}`}
                       id={`remove_${this.props.imageObject.field}`}
                        />
              </label>
            </div>
          </div>
        </div>
      </div> : null
    const errorElement = error ? <p className="inline-errors">{error}</p> : null



    return (
      [
        <label key={`${this.state.textAreaId}-0`}
               htmlFor={this.props.label.htmlFor}
               className={`${this.props.label.className} hidden`}>
                 {this.props.label.innerHTML}
        </label>,
        <textarea key={`${this.state.textAreaId}-1`}
                  id={this.state.textAreaId}
                  className='hidden'
                  readOnly={true}
                  name={uploadIdName}
                  value={this.props.imageObject.upload_id}>
        </textarea>,
        <textarea key={`${this.state.textAreaId}-1.5`}
                  id={this.state.textAreaId}
                  className='hidden'
                  readOnly={true}
                  name={mediaIdName}
                  value={this.state.slickr_media_upload_id}>
        </textarea>,
        <div key={`${this.state.textAreaId}-2`}
             className={`file input admin-big-title ${this.props.imageObject.id == null ? 'no_image' : 'has_image'} ${error ? 'has_error' : ''}`}>
          <div className="edit-wrapper">
            <label htmlFor="slickr_image_id">
              {`${this.props.imageObject.label}${hint}`}
              { this.props.imageObject.required ?
                    <abbr title="required">*</abbr> :
                    null }
            </label>
            <input type="file" onClick={this.openImagePicker()} />
            { imageElement }
            { errorElement }
          </div>
        </div>,
        <ImagePickerModal
          key={`${this.state.textAreaId}-3`}
          modalIsOpen={this.props.modalIsOpen}
          tags={this.props.tags}
          actions={actions}
          loadedImages={this.props.loadedImages}
          choosingActiveAdminImage={this.props.choosingActiveAdminImage}
          allowedUploadInfo={this.props.allowedUploadInfo}
          additionalInfo={this.props.additionalInfo}
        />
      ]
    );
  }
}
