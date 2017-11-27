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
      formData.append('image[attachment]', file);
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
            accept="image/jpeg, image/png, image/jpg"
            onDrop={this.onDrop}
          >
            <p className='main_text'>Drag and drop images here, <span className='alternative_text'>or select files from your computer</span>.</p>
            <p className='large-cta__hint'>Maximum size 10mb | .jpeg, .jpg and .png images only</p>
          </Dropzone>
        </div>
      </section>
    );
  }
}
