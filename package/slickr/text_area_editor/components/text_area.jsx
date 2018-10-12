import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftEditor, MegadraftIcons} from "megadraft";
import {editorStateToJSON, DraftJS} from "megadraft";
import LinkInput from '../../page_edit/components/content/megadraft_link_input_override.js'
import ImagePlugin from "../../page_edit/plugins/image/plugin.jsx";
import VimeoPlugin from "../../page_edit/plugins/vimeo/plugin.jsx";
import YouTubePlugin from "../../page_edit/plugins/you_tube/plugin.jsx";
import icons from "megadraft/lib/icons";
import h1 from "../../page_edit/text_editor_icons/h1.jsx"
import h2 from "../../page_edit/text_editor_icons/h2.jsx"
import h3 from "../../page_edit/text_editor_icons/h3.jsx"
import h4 from "../../page_edit/text_editor_icons/h4.jsx"
import h5 from "../../page_edit/text_editor_icons/h5.jsx"
import h6 from "../../page_edit/text_editor_icons/h6.jsx"
import mainAppPlugins from 'slickr_extensions/page_edit/plugins/plugin_list.js'
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
  {type: "block", label: "H5", style: "header-five", icon: h5},
  {type: "block", label: "H6", style: "header-six", icon: h6},
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
    let textareaList = document.querySelectorAll(
      '.megadraft-text-editor + .text textarea'
    );
    Array.prototype.forEach.call(textareaList, function(textarea, index) {
      if (activeIndex === index) {
        textarea.classList.add('active_textarea');
      } else {
        textarea.classList.remove('active_textarea');
      }
    })

    if(typeof editorState == 'object') {
      let rawDraft = editorStateToJSON(editorState)
      mainAppEditorStateChange(editorState, this.props, rawDraft)
    } else {
      mainAppEditorStateChange(editorState, this.props)
    }
  }

  render() {
    // megadraftOptions passed in as blockProps when set from plugin.jsx
    // use customOptions to pass in any extra info to plugin block
    // eg customOptions: { customAction: this.props.actions.customAction }

    // This has changed, now when you build a plugin you pass the Option
    // props directly to the commonBlock via the plugin import of the local
    // commonBlock we have created for slickr then the commonBlock builds as required
    var megadraftOptions = {
      customOptions: {},
      standardDisplayOptions: {
        displayOptions: [
          {"key": "thumb_limit", "icon": MegadraftIcons.MediaSmallIcon, "label": "THUMBNAIL"},
          {"key": "s_limit", "icon": MegadraftIcons.MediaSmallIcon, "label": "SMALL"},
          {"key": "m_limit", "icon": MegadraftIcons.MediaMediumIcon, "label": "MEDIUM"},
          {"key": "l_limit", "icon": MegadraftIcons.MediaBigIcon, "label": "LARGE"},
          {"key": "xl_limit", "icon": MegadraftIcons.MediaBigIcon, "label": "EXTRA LARGE"},
          {"key": "full", "icon": MegadraftIcons.MediaBigIcon, "label": "FULL"}
        ],
        defaultDisplay: 'full'
      }
    }
    var plugins = [ImagePlugin(megadraftOptions), VimeoPlugin, YouTubePlugin]
    let mergedPlugins = plugins.concat(mainAppPlugins)

    return (
      [
        <label key={`${this.props.textAreaIndex}-0`} htmlFor={this.props.label.htmlFor} className={this.props.label.className}>{this.props.labelText}</label>,
        <textarea key={`${this.props.textAreaIndex}-1`} onChange={this.hightlightActive} id={this.props.textArea.id} name={this.props.textArea.name} defaultValue={editorStateToJSON(this.props.editorState)}></textarea>,
        <MegadraftEditor
          key={`${this.props.textAreaIndex}-2`}
          editorState={this.props.editorState}
          onChange={this.changeEditorState}
          plugins={mergedPlugins}
          actions={mergedActions}
          entityInputs={mergedEntityInputs}
        />
      ]
    );
  }
}
