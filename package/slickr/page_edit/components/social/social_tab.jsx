import React from 'react';
import ReactDOM from 'react-dom';

export default class MetaTab extends React.Component {
  render() {
    const handleChange = this.props.handleChange
    const values = this.props.values
    console.log(this.props)
    return (
      <fieldset>
        <ol>
          <li className="input string admin-subtitle">
            <div className="edit-wrapper">
              <label htmlFor="og_title">Facebook og title</label>
              <input type="text" name="og_title" value={values.og_title} onChange={handleChange} />
            </div>
          </li>
          <li className="input text">
            <div className="edit-wrapper">
              <label htmlFor="og_description">Facebook og description</label>
              <textarea name="og_description" value={values.og_description} onChange={handleChange} />
              <p className='hint_text'></p>
            </div>
          </li>
          <li className="input string admin-subtitle">
            <div className="edit-wrapper">
              <label htmlFor="twitter_title">Twitter title</label>
              <input type="text" name="twitter_title" value={values.twitter_title} onChange={handleChange} />
            </div>
          </li>
          <li className="input text">
            <div className="edit-wrapper">
              <label htmlFor="twitter_description">Twitter description</label>
              <textarea name="twitter_description" value={values.twitter_description} onChange={handleChange} />
              <p className='hint_text'></p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}
