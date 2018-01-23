import React from 'react';
import ReactDOM from 'react-dom';
import Select from 'react-select';
import icons from "megadraft/lib/icons";
import page_store from 'slickr/package/slickr/packs/slickr_page_edit.jsx'
import text_editor_store from 'slickr/package/slickr/packs/slickr_text_area_editor.jsx'

export default class AdminLinkInput extends React.Component {
  constructor(props) {
    super(props);
    this.onAdminChange = this.onAdminChange.bind(this);
  }

  componentWillMount() {
    this.props.onChange('load_admins')
  }

  onAdminChange(selection) {
    var url = selection === null ? "" : selection.value
    if(selection !== null) {
      this.props.setEntity({url});
      this.props.cancelEntity();
      // Force blur to work around Firefox's NS_ERROR_FAILURE
      event.target.blur();
    } else {
      this.props.removeEntity();
    }
  }

  render() {
    const store = text_editor_store[0] ? text_editor_store[0].getState() : page_store.getState()

    var admins = store.loadedAdmins.map(
      ({email}, index) => (
        { value: `/a-link-${index}`, label: email }
      )
    )

    return (
      <Select
        name="form-field-name"
        value={this.props.url}
        options={admins}
        onChange={this.onAdminChange}
      />
    );
  }
}
