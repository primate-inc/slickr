import React from 'react';
import ReactDOM from 'react-dom';

export default class ConfigTab extends React.Component {
  render() {
    const handleChange = this.props.handleChange
    const values = this.props.values
    const layoutOptions = this.props.pageLayouts.map(function(layout, index){
      return <option key={index} value={layout.value}>{layout.display_name}</option>
    })
    return (
      <fieldset>
        <ol>
          <li className="input string">
            <div className="edit-wrapper">
              <label htmlFor="page_intro">Page layout</label>
              <select value={values.layout} onChange={handleChange} name="layout">
                { layoutOptions }
              </select>
              <p className='hint_text'></p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}

