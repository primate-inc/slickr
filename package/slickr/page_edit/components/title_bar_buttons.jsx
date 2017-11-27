import React from 'react';
import ReactDOM from 'react-dom';
import PublishSelect from './publish_select';
import cx from 'classnames';

export default class TitleBarButtons extends React.Component {
  constructor() {
    super();
    this.state = {
      publishingDropdownOpen: false
    };
  }
  mouseOver() {
    this.setState({publishingDropdownOpen: true});
  }
  mouseOut() {
    this.setState({publishingDropdownOpen: false});
  }
  render(){
    const containerClasses = cx({
      "action_item": true,
      "dropdown_item": true,
      "active": this.props.page.aasm_state == 'published' || this.props.page.publishing_scheduled_for
    })

    return(
        <div className="action_items">
          <span className="action_item"><a onClick={this.props.savePage} href='#'>Save page</a></span>
          <span className="action_item"><a href='#'><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-draft"></use></svg>Create draft</a></span>
          <span className="action_item"><a href='#'><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-preview"></use></svg>Preview</a></span>
          <div onMouseLeave={this.mouseOut.bind(this)} onMouseEnter={this.mouseOver.bind(this)}  className={containerClasses}>
            <PublishSelect publishing_scheduled_for={this.props.page.publishing_scheduled_for} startScheduling={this.props.startScheduling} unpublishPage={this.props.unpublishPage} unschedule={this.props.unschedule} published={this.props.page.aasm_state == 'published'} startScheduling={this.props.startScheduling} publishPage={this.props.publishPage} dropDownOpen={this.state.publishingDropdownOpen} />
            <span className="arrow"><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-down"></use></svg></span>
          </div>
        </div>
    )
  }
}


