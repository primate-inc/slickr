import React from 'react';
import ReactDOM from 'react-dom';
import cx from 'classnames';


export default class PublishedButton extends React.Component {
  constructor(props) {
      super(props);
      this.state = {hover: false};
    }
  mouseOver() {
    this.setState({hover: true});
  }
  mouseOut() {
    this.setState({hover: false});
  }

  render(){
    const buttonClasses = cx({
      "action_item": true,
      "fixed": true,
      "positive_item": !this.state.hover,
      "warning_item": this.state.hover
    })
    const button = this.state.hover ?
      <a onClick={this.props.publishPage}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-cross"></use></svg>Unpublish</a> :
      <a onClick={this.props.publishPage}><svg className="svg-icon"><use xmlnsXlink="http://www.w3.org/1999/xlink" xlinkHref="#svg-check"></use></svg>Published</a>
    return(
      <span onMouseOver={this.mouseOver.bind(this)} onMouseOut={this.mouseOut.bind(this)} className={buttonClasses}>{ button }</span>
    )
  }
}


