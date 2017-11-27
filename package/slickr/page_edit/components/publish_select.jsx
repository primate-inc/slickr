import React from 'react';
import ReactDOM from 'react-dom';
import moment from 'moment';
import ScheduledButton from './scheduled_button.jsx';


export default class PublishSelect extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }


  render(){
    const scheduledFor = this.props.publishing_scheduled_for ?
      moment(this.props.publishing_scheduled_for).format("ll") :
      null
    const buttonText = this.props.published ?
          "Published" :
            this.props.publishing_scheduled_for ?
            "Scheduled for " + scheduledFor :
            "Publish"
    const buttonIcon = this.props.published ?
      "publish" :
      this.props.publishing_scheduled_for ?
        "calendar" :
        "publish"
    return(
      <div className='dropdown_container'>
        <a><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref={"#svg-"+buttonIcon}></use></svg>{buttonText}</a>
        { this.props.dropDownOpen ?
          <div className='action_item_dropdown'>
            { this.props.published ?
              <span onClick={this.props.unpublishPage}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-cross"></use></svg>Unpublish</span> :
              <ScheduledButton publishing_schedule_for={this.props.publishing_schedule_for} publishPage={this.props.publishPage} />
            }
            { this.props.publishing_scheduled_for ?
              <span onClick={this.props.unschedule}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-cross"></use></svg>Cancel schedule</span> :
              <span onClick={this.props.startScheduling}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-calendar"></use></svg>Schedule</span>
             }
          </div> :
          null
        }
      </div>
      )
  }

}


