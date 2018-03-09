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
    const page = Object.keys(this.props.loadedImages).length === 0 ? 1 : (this.props.loadedImages.pagination_info.current_page + 1)
    this.props.actions.toggleChoosingPageHeaderImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) { this.props.actions.loadImages(page); }
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
                    <input type="text" name="page_header" value={values.page_header} onChange={handleChange} />
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
                <li className="file input admin-big-title">
                  <div className="edit-wrapper">
                    <label htmlFor="page_header_image">Page header image</label>
                    <input type="file" onClick={this.openImagePicker()} />
                    {(() => {
                      let image = this.props.page.page_header_image

                      if(!(image == null)) {
                        if(this.state.headerImagePath !== this.props.page.page_header_image) {
                          setFieldValue('page_header_image', image)
                          this.setState({headerImagePath: this.props.page.page_header_image})
                        }
                        let splitFile = this.props.page.page_header_image.split('/');
                        let fileName = splitFile[splitFile.length - 1];
                        let fileNameWithImageSize = image.replace(fileName, `small_${fileName}`)
                        return (
                          <p className="inline-hints">
                            <img src={fileNameWithImageSize} />
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
            if(!this.state.excludeList.includes("page_subheader")) {
              return (
                <li className="input string admin-big-title">
                  <div className="edit-wrapper">
                    <label htmlFor="page_subheader">Page subheader</label>
                    <input type="text" name="page_subheader" value={values.page_subheader} onChange={handleChange} />
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
                    <textarea type="textarea" name="page_intro" value={values.page_intro} onChange={handleChange} />
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
