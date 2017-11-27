import React from 'react';
import ReactDOM from 'react-dom';
import Editor from "./editor.jsx";

export default class ContentTab extends React.Component {
  render() {
    const page = this.props.page
    const actions = this.props.actions
    const editorState = this.props.editorState
    const handleChange = this.props.handleChange
    const values = this.props.values
    return (
      <fieldset>
        <ol>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="title">Page header</label>
              <input type="text" name="title" value={values.title} onChange={handleChange} />
              <p className='hint-text'>Your main page header</p>
            </div>
          </li>
          <li className="input string admin-subtitle">
            <div className="edit-wrapper">
              <label htmlFor="page_intro">Page introduction</label>
              <input type="text" name="page_intro" value={values.page_intro} onChange={handleChange} />
              <p className='hint-text'>Short summary of page content</p>
            </div>
          </li>
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
