import React from 'react';
import ReactDOM from 'react-dom';
import Editor from "./editor.jsx";

export default class ContentTab extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      excludeList: [],
      setExcludeList: false
    }
  }

  componentWillUnmount() {
    this.setState({ setExcludeList: false })
  }

  render() {
    const page = this.props.page
    const actions = this.props.actions
    const editorState = this.props.editorState
    const handleChange = this.props.handleChange
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
                    <input type="text" name="page_intro" value={values.page_intro} onChange={handleChange} />
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
