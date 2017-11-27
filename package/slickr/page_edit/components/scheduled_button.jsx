import React from 'react';
import ReactDOM from 'react-dom';
import moment from 'moment';

export default class ScheduledButton extends React.Component {
  render() {
    return(
      <div>
      { this.props.publishing_scheduled_for ?
        <span><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-calendar"></use></svg>Scheduled for {moment.format(this.props.publishing_scheduled_for).parse("llll")}</span> :
        <span onClick={this.props.publishPage}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-publish"></use></svg>Publish now</span>
      }
    </div>
)}}

