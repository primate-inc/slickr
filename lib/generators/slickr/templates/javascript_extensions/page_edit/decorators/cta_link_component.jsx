import React from "react";
import FaArrow from 'react-icons/lib/fa/arrow-right';

export default class CtaLink extends React.Component {
  render() {
    const contentState = this.props.contentState;
    const {url} = contentState.getEntity(this.props.entityKey).getData();
    return (
      <a className="custom-megadraft__link cita__link" style={{backgroundColor: '#00b5d6', padding: '.75em', borderRadius: '.75em'}} href={url} title={url}>
        {this.props.children}
      </a>
    );
  }
}
