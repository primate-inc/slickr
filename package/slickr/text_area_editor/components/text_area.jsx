import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftEditor} from "megadraft";
import {editorStateToJSON, DraftJS} from "megadraft";
import Video from "megadraft/lib/plugins/video/plugin";
import LinkInput from 'megadraft/lib/entity_inputs/LinkInput'
import ImagePlugin from "../../page_edit/plugins/image/plugin.jsx";
import icons from "megadraft/lib/icons";
import h1 from "../../page_edit/text_editor_icons/h1.jsx"
import h2 from "../../page_edit/text_editor_icons/h2.jsx"
import h3 from "../../page_edit/text_editor_icons/h3.jsx"
import h4 from "../../page_edit/text_editor_icons/h4.jsx"
import FaBook from 'react-icons/lib/fa/book';
import FaAuthor from 'react-icons/lib/fa/user';
import mainAppEntityInputs from 'slickr_extensions/page_edit/components/content/additional_entity_inputs.js'
import mainAppActions from 'slickr_extensions/page_edit/additional_megadraft_actions.js'
import mainAppEditorStateChange from 'slickr_extensions/page_edit/components/content/editor_state_change.js'

const slickrEntityInputs = {
  LINK: LinkInput
}

const mergedEntityInputs = Object.assign(slickrEntityInputs, mainAppEntityInputs);

const slickrActions = [
  {type: "inline", label: "B", style: "BOLD", icon: icons.BoldIcon},
  {type: "inline", label: "I", style: "ITALIC", icon: icons.ItalicIcon},
  // these actions correspond with the entityInputs above
  {type: "entity", label: "Link", style: "link", entity: "LINK", icon: icons.LinkIcon},

  {type: "separator"},
  {type: "block", label: "UL", style: "unordered-list-item", icon: icons.ULIcon},
  {type: "block", label: "OL", style: "ordered-list-item", icon: icons.OLIcon},
  {type: "block", label: "H1", style: "header-one", icon: h1},
  {type: "block", label: "H2", style: "header-two", icon: h2},
  {type: "block", label: "H3", style: "header-three", icon: h3},
  {type: "block", label: "H4", style: "header-four", icon: h4},
  {type: "block", label: "QT", style: "blockquote", icon: icons.BlockQuoteIcon}
];

const mergedActions = slickrActions.concat(mainAppActions);

export default class Editor extends React.Component {
  constructor(props) {
    super(props);

    this.changeEditorState = this.changeEditorState.bind(this);
  }

  changeEditorState(editorState) {
    let activeIndex = this.props.textAreaIndex
    let textareaList = document.getElementsByTagName('textarea');
    Array.prototype.forEach.call(textareaList, function(textarea, index) {
      if (activeIndex === index) {
        textarea.classList.add('active_textarea');
      } else {
        textarea.classList.remove('active_textarea');
      }
    })

    mainAppEditorStateChange(editorState, this.props)
  }

  render() {
    // megadraftOptions passed in as blockProps when set from plugin.jsx
    // use customOptions to pass in any extra info to plugin block
    // eg customOptions: { customAction: this.props.actions.customAction }
    var megadraftOptions = {
      customOptions: {},
      standardDisplayOptions: {
        displayOptions: [],
        defaultDisplay: null
      }
    }
    var plugins = [ImagePlugin(megadraftOptions), Video]

    return (
      [
        <label key={`${this.props.textAreaIndex}-0`} htmlFor={this.props.label.htmlFor} className={this.props.label.className}>{this.props.label.innerHTML}</label>,
        <textarea key={`${this.props.textAreaIndex}-1`} onChange={this.hightlightActive} id={this.props.textArea.id} name={this.props.textArea.name} defaultValue={editorStateToJSON(this.props.editorState)}></textarea>,
        <MegadraftEditor
          key={`${this.props.textAreaIndex}-2`}
          editorState={this.props.editorState}
          onChange={this.changeEditorState}
          plugins={plugins}
          actions={mergedActions}
          entityInputs={mergedEntityInputs}
        />
      ]
    );
  }
}
