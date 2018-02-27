import React from "react";

export default class AdminLink extends React.Component {
  render() {
    const contentState = this.props.contentState;
    const {url} = contentState.getEntity(this.props.entityKey).getData();
    return (
      <a className="custom-megadraft__link admin__link" href={url} title={url}>
        {this.props.children}
      </a>
    );
  }
}
