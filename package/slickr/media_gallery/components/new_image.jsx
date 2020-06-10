import React from 'react';
import ReactDOM from 'react-dom';
import Dropzone from 'react-dropzone';

export default class NewImage extends React.Component {
  constructor() {
    super()
    this.state = { files: [] }

    this.onDrop = this.onDrop.bind(this);
  }

  onDrop(files) {
    files.forEach((file)=> {
      const formData = new FormData();

      if(this.props.allowedUploadInfo.file_mime_types.indexOf(file.type) > -1) {
        formData.append('slickr_media_upload[file]', file);
        if(this.props.tags) {
          formData.append('slickr_media_upload[media_tag_list]', this.props.tags);
        }
      } else {
        formData.append('slickr_media_upload[image]', file);
        if(this.props.tags) {
          formData.append('slickr_media_upload[media_tag_list]', this.props.tags);
        }
      }
      this.props.actions.createImage({
        formData: formData, file: file, upload: true
      })
    });
  }

  render() {
    return (
      <section>
        <div>
          <Dropzone
            className='dropzone'
            activeClassName='dropzone-acive'
            accept={this.props.allowedUploadInfo.allowed_mime_types}
            onDrop={this.onDrop}
          >
            <p className='main_text'>Drag and drop images here,
              <span className='alternative_text'>
                &nbsp; or select files from your computer
              </span>.
            </p>
            <p className='large-cta__hint'>
              {this.props.allowedUploadInfo.drop_area_text}
            </p>
          </Dropzone>
        </div>
      </section>
    );
  }
}
