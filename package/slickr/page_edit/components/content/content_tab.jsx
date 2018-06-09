import React from 'react';
import ReactDOM from 'react-dom';
import Editor from "./editor.jsx";

export default class ContentTab extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      excludeList: [],
      setExcludeList: false,
      headerImagePath: this.props.page.page_header_image
    }
  }

  componentWillUnmount() {
    this.setState({ setExcludeList: false })
  }

  openImagePicker = () => (e) => {
    e.preventDefault();
    const page = Object.keys(this.props.loadedImages).length === 0 ? 1 : (this.props.loadedImages.pagination_info.current_page)
    this.props.actions.toggleChoosingPageHeaderImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) { this.props.actions.loadImages(page); }
  }

  updateTrueFalse = () => (e) => {
    let box = e.target.closest('.true_false');
    if(e.target.checked === true) {
      box.classList.add('checked');
    } else {
      box.classList.remove('checked');
    }
  }

  render() {
    const page = this.props.page
    const actions = this.props.actions
    const editorState = this.props.editorState
    const handleChange = this.props.handleChange
    const setFieldValue = this.props.setFieldValue
    const values = this.props.values
    if(this.props.pageLayouts.length !== 0 && !this.state.setExcludeList) {
      this.setState({
        excludeList: this.props.pageLayouts.find(function (obj) { return obj.value === page.layout }).exclude,
        setExcludeList: true
      })
    }

    return (
      <fieldset>
        <ol>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="title">Title</label>
              <input type="text" name="title" value={values.title} onChange={handleChange} />
              <p className='hint-text'>Navigation title</p>
            </div>
          </li>
          {(() => {
            if(!this.state.excludeList.includes("page_header")) {
              return (
                <li className="input string admin-big-title">
                  <div className="edit-wrapper">
                    <label htmlFor="page_header">Page header</label>
                    <textarea type="textarea" name="page_header" value={values.page_header} onChange={handleChange} />
                    <p className='hint-text'>Your main page header</p>
                  </div>
                </li>
              )
            }
          })()}
          {(() => {
            if(!this.state.excludeList.includes("page_header_image")) {
              let image = this.props.page.page_header_image
              return (
                <li className={`file input admin-big-title ${this.props.page.slickr_image_path == null ? 'no_image' : 'has_image'}`}>
                  <div className="edit-wrapper">
                    <label htmlFor="slickr_image_id">Page header image</label>
                    <input type="file" onClick={this.openImagePicker()} />
                    {(() => {
                      console.log(this.props)
                      let imageId = this.props.page.slickr_image_id
                      let imagePath = this.props.page.slickr_image_path

                      if(!(imagePath == null)) {
                        if(this.state.imagePath !== imagePath) {
                          setFieldValue('slickr_media_upload_id', imageId)
                          this.setState({
                            imagePath: imagePath
                          })
                        }
                        return (
                          <p className="inline-hints">
                            <img src={imagePath} />
                          </p>
                        )
                      }
                    })()}
                    <p className='hint-text'>Your main page header image</p>
                  </div>
                </li>
              )
            }
          })()}
          {(() => {
            if(!this.state.excludeList.includes("page_header_image")) {
              let imagePath = this.props.page.slickr_image_path
              if(!(imagePath == null)) {
                return (
                  <li className="true_false image boolean input optional">
                    <div className="edit-wrapper">
                      <label htmlFor="remove_page_header_image">
                        <input type="checkbox"
                               name="remove_page_header_image"
                               id='remove_page_header_image'
                               onChange={handleChange}
                               onClick={this.updateTrueFalse()} />Remove image
                      </label>
                    </div>
                  </li>
                )
              }
            }
          })()}
          {(() => {
            if(!this.state.excludeList.includes("page_subheader")) {
              return (
                <li className="input string admin-big-title">
                  <div className="edit-wrapper">
                    <label htmlFor="page_subheader">Page subheader</label>
                    <textarea type="textarea"
                              name="page_subheader"
                              value={values.page_subheader}
                              onChange={handleChange} />
                    <p className='hint-text'>Your main page subheader</p>
                  </div>
                </li>
              )
            }
          })()}
          {(() => {
            if(!this.state.excludeList.includes("page_intro")) {
              return (
                <li className="input string admin-subtitle">
                  <div className="edit-wrapper">
                    <label htmlFor="page_intro">Page introduction</label>
                    <textarea type="textarea"
                              name="page_intro"
                              value={values.page_intro}
                              onChange={handleChange} />
                    <p className='hint-text'>Short summary of page content</p>
                  </div>
                </li>
              )
            }
          })()}
          <li className="input string megadraft">
            <div className="edit-wrapper">
              <label htmlFor="content">Page content</label>
              <Editor editorState={editorState} actions={actions}/>
              <p className='hint_text'></p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}
