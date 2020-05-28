import React from 'react';
import ReactDOM from 'react-dom';
import ImagePickerModal from '../../page_edit/components/content/image_picker_modal.jsx';

export default class ImageArea extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      slickr_media_upload_id: this.props.imageObject.id
    }
  }

  componentDidUpdate(prevProps) {
    if(this.props.imageObject.id !== prevProps.imageObject.id) {
      this.setState({
        slickr_media_upload_id: this.props.imageObject.id
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
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
  }

  removeImage = () => (e) => {
    this.setState({
      slickr_media_upload_id: 'nil'
    })
    this.props.actions.updateActiveAdminImage({ id: null, path: null })
  }

  render() {
    const actions = this.props.actions
    const textAreaName = this.props.textArea.name.slice(0, -1) +
                         '_attributes][slickr_media_upload_id]'
    const error = this.props.imageObject.errors[0]

    let hint;
    if(this.props.imageObject.hint == '') {
      hint = ''
    } else {
      hint = ` (${this.props.imageObject.hint}) `
    }

    return (
      [
        <label key={`${this.props.textAreaIndex}-0`}
               htmlFor={this.props.label.htmlFor}
               className={`${this.props.label.className} hidden`}>
                 {this.props.label.innerHTML}
        </label>,
        <textarea key={`${this.props.textAreaIndex}-1`}
                  onChange={this.hightlightActive}
                  id={this.props.textArea.id}
                  className='hidden'
                  name={textAreaName}
                  value={this.state.slickr_media_upload_id}>
        </textarea>,
        <div key={`${this.props.textAreaIndex}-2`}
             className={`file input admin-big-title ${this.props.imageObject.id == null ? 'no_image' : 'has_image'} ${error ? 'has_error' : ''}`}>
          <div className="edit-wrapper">
            <label htmlFor="slickr_image_id">
              {`${this.props.imageObject.label}${hint}`}
              { this.props.imageObject.required ?
                    <abbr title="required">*</abbr> :
                    null }
            </label>
            <input type="file" onClick={this.openImagePicker()} />
            {(() => {
              let mediaUploadId = this.props.imageObject.id
              let imagePath = this.props.imageObject.path

              if(imagePath != null) {
                return (
                  <div className="inline-hints">
                    <img src={imagePath} />
                    <div className={`image-picker-remove ${mediaUploadId == null ? 'no_image' : 'has_image'}`}>
                      <div className="true_false image boolean input optional">
                        <div className="edit-wrapper">
                          <label className='label_remove' htmlFor={`remove_${this.props.imageObject.field}`}>
                            <input type="checkbox"
                                   name={`remove_${this.props.imageObject.field}`}
                                   id={`remove_${this.props.imageObject.field}`}
                                   onClick={this.removeImage()} />
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
