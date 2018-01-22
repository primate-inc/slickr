import {editorStateToJSON, DraftJS} from "megadraft";

const editorStateChange = (editorState, props) => {
  console.log(props.textAreaIndex)
  if(props.textAreaIndex.length !== -1) {
    document.getElementById(props.textArea.id).value = editorStateToJSON(editorState)
    props.actions.changeEditorState(editorState)
  } else if(editorState === 'load_admins') {
    props.actions.loadAdmins()
  } else {
    props.actions.changeEditorState(editorState)
  }
}

export default editorStateChange
