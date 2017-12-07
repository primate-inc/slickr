const editorStateChange = (editorState, props) => {
  if(editorState === 'load_admins')
    props.actions.loadAdmins()
  else
    props.actions.changeEditorState(editorState)
}

export default editorStateChange
