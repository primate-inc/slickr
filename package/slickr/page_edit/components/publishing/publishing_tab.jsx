import React from 'react';
import ReactDOM from 'react-dom';
import InputMoment from 'input-moment'
import moment from 'moment';

import cx from 'classnames';

export default class PublishingTab extends React.Component {
  state = {
      m: moment()
    };
  handleChange = m => {
      this.setState({ m });
    }
  render() {
    const handleChange = this.props.handleChange
    const values = this.props.values
    const schedulingActive = this.props.schedulingActive;
    const actions = this.props.actions
    const infoText = this.props.page.aasm_state == "published" ? <h2 >{this.props.page.title} is published</h2> : <h2>{this.props.page.title} is unpublished</h2>

    return (
      <div className='publishing-section'>
        <div className='schedule-calendar'>
          {infoText}

          <p className='info-text'>Set publishing date to: <br /> {this.state.m.format('llll')} <button className='action_item' href='#'>Save changes</button></p>
          <InputMoment
            moment={this.state.m}
            onChange={this.handleChange}
            onSave={this.handleSave}
            minStep={1} // default
            hourStep={1} // default
            prevMonthIcon="ion-ios-arrow-left" // default
            nextMonthIcon="ion-ios-arrow-right" // default
          />
          <p className='info-text'>Select date and time for the post to appear on your website or <a href='#' onClick={this.props.actions.setNewPublishingSchedule(null)}>cancel publishing schedule</a></p>
        </div>
      </div>
    );
  }
}
