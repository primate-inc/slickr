// import {editorStateToJSON} from "megadraft";

const editorState = (state = {}, action) => {
  switch(action.type) {
    case 'CHANGE_EDITOR_STATE':
      return action.payload;

    default:
      return state
  }
}

export default editorState
