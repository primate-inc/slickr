import React from 'react';
import ReactDOM from 'react-dom';
import Select from 'react-select';
import icons from "megadraft/lib/icons";
import page_store from 'slickr_cms/package/slickr/packs/slickr_page_edit.jsx'
import text_editor_store from 'slickr_cms/package/slickr/packs/slickr_text_area_editor.jsx'

export default class PdfLinkInput extends React.Component {
  constructor(props) {
    super(props);
    this.onPdfChange = this.onPdfChange.bind(this);
    this.loadData = this.loadData.bind(this);

    this.state = {
      loading: false,
      pdfs: { pdf_files: [] }
    }
  }

  loadData = (index) => {
    var promise = new Promise((resolve, reject) => {
      (function waitForData(){
        if(text_editor_store[index]) {
          if ('pdf_path' in text_editor_store[index].getState().loadedPdfs) return resolve();
          setTimeout(waitForData, 30);
        } else {
          if ('pdf_path' in page_store.getState().loadedPdfs) return resolve();
          setTimeout(waitForData, 30);
        }
      })();
    });
    return promise;
  }

  componentWillMount() {
    let textAreaStoreIndex = 0
    let textareaList = document.getElementsByTagName('textarea');

    Array.prototype.forEach.call(textareaList, function(textarea, index) {
      if (textarea.classList.contains('active_textarea')) textAreaStoreIndex = index
    })
    this.props.onChange('load_pdfs')

    this.loadData(textAreaStoreIndex).then(() => {
      let pdfs = text_editor_store[textAreaStoreIndex] ? text_editor_store[textAreaStoreIndex].getState().loadedPdfs : page_store.getState().loadedPdfs
      this.setState({
        pdfs: pdfs,
        loading: false
      });
    });
  }

  onPdfChange(selection) {
    let url = selection === null ? "" : selection.value
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
    let pdfs = this.state.pdfs.pdf_files.map(
      (file, index) => (
        {
          value: `${this.state.pdfs.pdf_path}?id=${file.id}`,
          label: file.file_data.original.metadata.filename
        }
      )
    )

    return (
      <Select
        name="form-field-name"
        value={this.props.url}
        options={pdfs}
        onChange={this.onPdfChange}
      />
    );
  }
}
