import React from 'react';
import ReactDOM from 'react-dom';

export default class Buttons extends React.Component {
  constructor(props){
    super(props);

    this.onSelectClearAll = this.onSelectClearAll.bind(this);
    this.DeleteSelectedImages = this.DeleteSelectedImages.bind(this);
  }

  onSelectClearAll() {
    this.props.actions.clearAllSelected(
      this.props.selectedImages.map(function(i) { return i.id; })
    )
  }

  DeleteSelectedImages() {
    this.props.actions.deleteSelectedImages(
      this.props.selectedImages.map(function(i) { return i.id; })
    )
  }

  showEditButton() {
    if (this.props.selectedImages.length === 1){
      const mimeType = this.props.selectedImages[0].mimeType

      if(this.props.allowedUploadInfo.file_mime_types.indexOf(mimeType) > -1) {
        return <a href='#' className='actions hidden'>Edit</a>
      } else {
        var href = this.props.selectedImages[0].editPath
        return (
          <a href={href} className='active actions'>Edit</a>
        )
      }
    } else {
      return <a href='#' className='actions hidden'>Edit</a>
    }
  }

  showTopBar() {
    var barClass = this.props.selectedImages.length > 0 ? 'visible' : ''
    return (
      <div id='image-gallery-bar' className={barClass}>
        <div className='image-gallery-actions'>
          <div className='number-selected'>
            <div className='number-selected-info'
                 onClick={this.onSelectClearAll}
            >{`${this.props.selectedImages.length} Selected`}</div>
          </div>
          <div className='buttons'>
            {this.showEditButton()}
            <a href='#' className='active actions'
               onClick={ this.DeleteSelectedImages }
            >Delete</a>
          </div>
        </div>
      </div>
    )
  }

  render(){
    return(
      <div>
        { this.showTopBar() }
      </div>
    )
  }
}
