import React from 'react';
import ReactDOM from 'react-dom';

export default class Publishing extends React.Component {
  render(){
    return(
      this.props.page.aasm_state == 'published' ?
      <div onClick={this.props.actions.pageUnpublish}>Unpublish</div> :
      <div onClick={this.props.actions.pagePublish}>Publish</div>
    )
  }
}
