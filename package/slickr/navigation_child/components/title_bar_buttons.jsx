import React from 'react';
import ReactDOM from 'react-dom';

export default class TitleBarButtons extends React.Component {
  render(){
    return(
        <div className="action_items">
          <span className="action_item">
            <a onClick={this.props.saveNavigation} href='#'>Save navigation</a>
          </span>
        </div>
    )
  }
}
