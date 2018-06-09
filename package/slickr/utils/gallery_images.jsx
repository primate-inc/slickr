import React from 'react';

export default function(images) {
  return images.map((i) => {
    var altClass = i.additional_info.alt_text == '' ? 'alt_text_missing' : ''
    var progressState
    switch (i.state) {
      case undefined:
        progressState = 'progress_uploaded';
        break;
      case 'started':
        progressState = 'progress_uploading';
        break;
      case 'error':
        progressState = 'progress_error';
        break;
    }
    i.build_for_gallery.customOverlay = (
      <div>
        <div style={captionStyle} >
          <div>{i.build_for_gallery.caption}</div>
          {
            i.build_for_gallery.hasOwnProperty('tags')
            && this.setCustomTags(i.build_for_gallery)
          }
        </div>
        <div className={altClass}></div>
        <div className={progressState}>
          <div className={progressState === 'progress_uploading' ? 'progress_container' : ''}>
            <div className={progressState === 'progress_uploading' ? 'progress_bar' : ''}
                 style={{width: i.uploadProgressValue + '%'}}>&nbsp;</div>
          </div>
        </div>
      </div>
    );
    return i;
  })
};

const captionStyle = {
  backgroundColor: 'rgba(0, 0, 0, 0.8)',
  maxHeight: '240px',
  overflow: 'hidden',
  position: 'absolute',
  bottom: '0',
  width: '100%',
  color: 'white',
  padding: '2px',
  fontSize: '90%'
};
