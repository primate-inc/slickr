import React from "react";

export default class BookLink extends React.Component {
  render() {
    const contentState = this.props.contentState;
    const {url} = contentState.getEntity(this.props.entityKey).getData();
    return (
      <a className="book__link" href={url} title={url}>
        {this.props.children}
      </a>
    );
  }
}
