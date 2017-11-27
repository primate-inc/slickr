import React from 'react';
import ReactDOM from 'react-dom';
import Select from 'react-select';
import icons from "megadraft/lib/icons";
import store from '../../packs/page_edit.jsx'

export default class BookLinkInput extends React.Component {
  constructor(props) {
    super(props);
    this.onBookChange = this.onBookChange.bind(this);
  }

  componentWillMount() {
    this.props.onChange('load_books')
  }

  onBookChange(selection) {
    var url = selection === null ? "" : selection.value
    if(selection !== null) {
      this.props.setEntity({url});
      this.props.cancelEntity();
      // // Force blur to work around Firefox's NS_ERROR_FAILURE
      event.target.blur();
    } else {
      this.props.removeEntity();
    }
  }

  render() {
    var books = store.getState().loadedBooks.map(
      ({title}, index) => (
        { value: `/a-link-${index}`, label: title }
      )
    )
    var value = this.props.url === null ? "" : this.props.url
    return (
      <Select
        name="form-field-name"
        value={this.props.url}
        options={books}
        onChange={this.onBookChange}
      />
    );
  }
}
