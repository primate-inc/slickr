import React from 'react';
import ReactDOM from 'react-dom';
import ImagePickerModal from '../../page_edit/components/content/image_picker_modal.jsx';

export default class newImageAreaMultiple extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      slickr_media_upload_id: null,
      slickr_media_upload_path: null,
      newObject: this.props.newObject,
      errors: []
    }
  }

  componentDidUpdate(prevProps) {
    if(this.props.imageObject && (this.props.imageObject.id !== prevProps.imageObject.id) && (this.props.newImageFieldId == this.props.textAreaName)) {
      this.setState({
        slickr_media_upload_id: this.props.imageObject.id,
        slickr_media_upload_path: this.props.imageObject.path,
      })
    }
  }

  openImagePicker(id, e) {
    e.preventDefault();
    let page
    if(Object.keys(this.props.loadedImages).length === 0) {
      page = 1
    } else {
      page = this.props.loadedImages.pagination_info.current_page
    }
    this.props.actions.toggleChoosingActiveAdminImage();
    this.props.actions.toggleImagePicker();
    this.props.actions.updateNewImageFieldId(id);
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
  }

  removeImage(id) {
    this.props.actions.updateNewImageFieldId(id);
    this.setState({
      slickr_media_upload_id: 'nil',
      slickr_media_upload_path: null
    })
    // this.props.actions.updateActiveAdminImage({ id: null, path: null })
  }

  render() {
    const actions = this.props.actions
    const textAreaName = this.props.textAreaName
    const uploadIdName = textAreaName + '[id]'
    const mediaIdName = textAreaName + '[slickr_media_upload_id]'
    const error = this.state.errors[0]

    let hint;
    if(this.props.hint == '') {
      hint = ''
    } else {
      hint = ` (${this.props.hint}) `
    }

    return (
      [
        <label key={`${this.props.textAreaIndex}-0`}
               htmlFor={this.props.label}
               className={`${this.props.label} hidden`}>
                 {this.props.label}
        </label>,
        <textarea key={`${this.props.textAreaIndex}-1.5`}
                  onChange={this.hightlightActive}
                  id={textAreaName}
                  className='hidden'
                  name={mediaIdName}
                  value={this.state.slickr_media_upload_id}>
        </textarea>,
        <div key={`${this.props.textAreaIndex}-2`}
             className={`file input admin-big-title ${this.state.slickr_media_upload_id == null ? 'no_image' : 'has_image'} ${error ? 'has_error' : ''}`}>
          <div className="edit-wrapper">
            <label htmlFor="slickr_image_id">
              {`${this.props.label}${hint}`}
              { this.props.newObject.required ?
                    <abbr title="required">*</abbr> :
                    null }
            </label>
            <input type="file" onClick={this.openImagePicker.bind(this, textAreaName)} />
            {(() => {
              let mediaUploadId = this.state.slickr_media_upload_id
              let imagePath = this.state.slickr_media_upload_path

              if(imagePath != null) {
                return (
                  <div className="inline-hints">
                    <img src={imagePath} />
                    <div className={`image-picker-remove ${mediaUploadId == null ? 'no_image' : 'has_image'}`}>
                      <div className="true_false image boolean input optional">
                        <div className="edit-wrapper">
                          <label onClick={this.removeImage.bind(this, textAreaName)} className='label_remove' htmlFor={`remove_${this.props.mediaIdName}`}>
                            <input type="checkbox"
                                   name={`remove_${textAreaName}`}
                                   data-text_area={textAreaName}
                                   id={`remove_${textAreaName}`}
                                   />
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                )
              }
            })()}
            {(() => {
              if(error) {
                return (
                  <p class="inline-errors">{error}</p>
                )
              }
            })()}
          </div>
        </div>,
        <ImagePickerModal
          key={`${this.props.textAreaIndex}-3`}
          modalIsOpen={this.props.modalIsOpen}
          tags={this.props.tags}
          actions={this.props.actions}
          loadedImages={this.props.loadedImages}
          choosingActiveAdminImage={this.props.choosingActiveAdminImage}
          allowedUploadInfo={this.props.allowedUploadInfo}
          additionalInfo={this.props.additionalInfo}
        />
      ]
    );
  }
}
