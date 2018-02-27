import {editorStateToJSON, DraftJS} from "megadraft";

const editorStateChange = (editorState, props) => {
  if(editorState === 'load_pdfs') {
    props.actions.loadPdfs()
  } else if(props.textArea)  {
    document.getElementById(props.textArea.id).value = editorStateToJSON(editorState)
    props.actions.changeEditorState(editorState)
  } else  {
    props.actions.changeEditorState(editorState)
  }
}

export default editorStateChange
