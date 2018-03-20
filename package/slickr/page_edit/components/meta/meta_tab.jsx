import React from 'react';
import ReactDOM from 'react-dom';

export default class MetaTab extends React.Component {
  render() {
    const handleChange = this.props.handleChange
    const values = this.props.values
    return (
      <fieldset>
        <ol>
          <li className="input string admin-subtitle">
            <div className="edit-wrapper">
              <label htmlFor="page_title">Page title</label>
              <input type="text" name="page_title" value={values.page_title} onChange={handleChange} />
            </div>
          </li>
          <li className="input string">
            <div className="edit-wrapper">
              <label htmlFor="page_intro">Page meta description</label>
              <input type="text" name="meta_description" value={values.meta_description} onChange={handleChange} />
              <p className='hint_text'></p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}
