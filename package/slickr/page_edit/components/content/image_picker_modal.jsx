import React from 'react';
import ReactDOM from 'react-dom';
import ReactModal from 'react-modal';
import Grid from './grid.jsx';

export default class ImagePickerModal extends React.Component {
  constructor(props) {
    super();
  }

  closeImagePicker = (e) => {
    // this.props.actions.keepCurrentPage()
    this.props.actions.toggleImagePicker()
    if(this.props.choosingGalleryImage) {
      this.props.actions.toggleChoosingGalleryImage();
    }
  }

  loadNewImages = (page) => (e) => {
    this.props.actions.showLoader();
    this.props.actions.loadImages(page);
  }

  prev = (e) => {
    const pagination = this.props.loadedImages.pagination_info
    if(pagination) {
      if(pagination.current_page !== 1) {
        return ([
          <span key='1' className='first'><a href='#' onClick={this.loadNewImages(1)}>« First</a></span>,
          <span key='2' className='prev'><a rel="prev" href='#' onClick={this.loadNewImages(pagination.current_page - 1)}>‹ Prev</a></span>
        ])
      }
    }
  }

  next = (e) => {
    const pagination = this.props.loadedImages.pagination_info
    if(pagination) {
      if(pagination.current_page !== pagination.total_pages) {
        return ([
          <span key='1' className='next'><a rel='next' href='#' onClick={this.loadNewImages(pagination.current_page + 1)}>Next ›</a></span>,
          <span key='2' className='last'><a href='#' onClick={this.loadNewImages(pagination.total_pages)}>Last ››</a></span>
        ])
      }
    }
  }

  pages = (e) => {
    const pagination = this.props.loadedImages.pagination_info
    const that = this
    let pages = []
    if(pagination) {
      const pageArray = [...Array(pagination.total_pages).keys()]
      pageArray.forEach(function(page) {
        if(page + 1 === pagination.current_page) {
          pages.push(<span key={page} className='page current'>{page+1}</span>)
        } else {
          pages.push(<span key={page} className='page'><a href='#' onClick={that.loadNewImages(page+1)}>{page+1}</a></span>)
        }
      });
    }
    return pages
  }

  loading_or_images = (e) => {
    if(this.props.loadedImages.loading || this.props.loadedImages.loading === undefined) {
      return (
        <div className="loader_box">
          <div className="loader">
            <svg className="circular" viewBox="25 25 50 50">
              <circle className="path" cx="50" cy="50" r="20" fill="none" strokeWidth="2" strokeMiterlimit="10"/>
            </svg>
          </div>
        </div>
      )
    } else {
      const images = Object.keys(this.props.loadedImages).length === 0 ? [] : this.props.loadedImages.images
      return ([
        <div key='1' style={{overflow: "auto", height: "100%"}}>
          <Grid
            actions={this.props.actions}
            images={images}
            editorState={this.props.editorState}
            pageHeaderImage={this.props.pageHeaderImage}
            choosingPageHeaderImage={this.props.choosingPageHeaderImage}
            choosingNavImage={this.props.choosingNavImage}
            choosingGalleryImage={this.props.choosingGalleryImage}
          />
        </div>,
        <div key='2' id="index_footer">
          <nav className="pagination">
            {this.prev()}
            {this.pages()}
            {this.next()}
          </nav>
        </div>,
        <div key='3' onClick={this.closeImagePicker} className="ReactModal__close_button"><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-cross"></use></svg><span>Close</span></div>
      ])
    }
  }

  render(){
    return(
      <ReactModal
        isOpen={this.props.modalIsOpen}
        contentLabel="onRequestClose Example"
        onRequestClose={this.closeImagePicker}
        style={{content: {overflow: "visible"}}}
      >
        {this.loading_or_images()}
      </ReactModal>
    )
  }
}
