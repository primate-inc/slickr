import React from 'react';
import ReactDOM from 'react-dom';
import {MegadraftEditor} from "megadraft";
import Video from "megadraft/lib/plugins/video/plugin";
import LinkInput from 'megadraft/lib/entity_inputs/LinkInput'
import ImagePlugin from "../../plugins/image/plugin.jsx";
import icons from "megadraft/lib/icons";
import h1 from "../../text_editor_icons/h1.jsx"
import h2 from "../../text_editor_icons/h2.jsx"
import h3 from "../../text_editor_icons/h3.jsx"
import h4 from "../../text_editor_icons/h4.jsx"
import FaBook from 'react-icons/lib/fa/book';
import FaAuthor from 'react-icons/lib/fa/user';
import BookLinkInput from "../../entity_inputs/book_link_input.jsx";
import AuthorLinkInput from "../../entity_inputs/author_link_input.jsx";

const entityInputs = {
  LINK: LinkInput,
  BOOK_LINK: BookLinkInput,
  AUTHOR_LINK: AuthorLinkInput
}

const actions = [
  {type: "inline", label: "B", style: "BOLD", icon: icons.BoldIcon},
  {type: "inline", label: "I", style: "ITALIC", icon: icons.ItalicIcon},
  // these actions correspond with the entityInputs above
  {type: "entity", label: "Link", style: "link", entity: "LINK", icon: icons.LinkIcon},
  {type: "entity", label: "Book Link", style: "link", entity: "BOOK_LINK", icon: FaBook},
  {type: "entity", label: "Author Link", style: "link", entity: "AUTHOR_LINK", icon: FaAuthor},

  {type: "separator"},
  {type: "block", label: "UL", style: "unordered-list-item", icon: icons.ULIcon},
  {type: "block", label: "OL", style: "ordered-list-item", icon: icons.OLIcon},
  {type: "block", label: "H1", style: "header-one", icon: h1},
  {type: "block", label: "H2", style: "header-two", icon: h2},
  {type: "block", label: "H3", style: "header-three", icon: h3},
  {type: "block", label: "H4", style: "header-four", icon: h4},
  {type: "block", label: "QT", style: "blockquote", icon: icons.BlockQuoteIcon}
];

export default class Editor extends React.Component {
  constructor(props) {
    super(props);

    this.changeEditorState = this.changeEditorState.bind(this);
  }

  changeEditorState(editorState) {
    if(editorState === 'load_books')
      this.props.actions.loadBooks()
    else if(editorState === 'load_authors')
      this.props.actions.loadAuthors()
    else
      this.props.actions.changeEditorState(editorState)
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
        <MegadraftEditor
          editorState={this.props.editorState}
          onChange={this.changeEditorState}
          plugins={plugins}
          actions={actions}
          entityInputs={entityInputs}
        />
      );
    }
}
