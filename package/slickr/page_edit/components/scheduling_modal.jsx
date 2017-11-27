import React from 'react';
import ReactDOM from 'react-dom';
import ReactModal from 'react-modal';
import InputMoment from 'input-moment'
import moment from 'moment';


export default class SchedulingModal extends React.Component {
  constructor(props) {
    super();
    this.closeScheduling = this.closeScheduling.bind(this);
    this.state = {m: props.publishing_scheduled_for ? moment(props.pubishing_scheduled_for) : moment()}
  }

  handleChange = m => {
    this.setState({ m });
  }

  saveSchedule () {
    this.props.actions.saveSchedule(this.state.m.toISOString())
  }

  closeScheduling () {
    this.props.actions.cancelScheduling()
  }

  render(){
    return(
      <ReactModal
        portalClassName="scheduling-modal"
        isOpen={this.props.modalIsOpen}
        contentLabel="onRequestClose Example"
        onRequestClose={this.closeScheduling}
        style={{content: {left: "auto", right: "40px", bottom: "auto", overflow: "visible"}}}
      >
        <div style={{overflow: "auto", height: "100%"}}>
          <InputMoment
            moment={this.state.m}
            onChange={this.handleChange}
            onSave={this.handleSave}
            minStep={1} // default
            hourStep={1} // default
            prevMonthIcon="ion-ios-arrow-left" // default
            nextMonthIcon="ion-ios-arrow-right" // default
          />
          <div onClick={this.saveSchedule.bind(this)} className="action_item">Save</div>
        </div>
        <div onClick={this.closeScheduling} className="ReactModal__close_button"><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-cross"></use></svg><span>Close</span></div>
      </ReactModal>
    )
  }
}

