import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import NavigationWrapper from '../components/navigation_wrapper.jsx'
import * as NavigationActions from '../actions'

const NavigationEditor = ({
    navigation, parent, childTypes, selectablePages, modalIsOpen,
    loadedImages, choosingImage, actions, store
}) => {
  return(
    <NavigationWrapper  navigation={navigation}
                        parent={parent}
                        childTypes={childTypes}
                        selectablePages={selectablePages}
                        modalIsOpen={modalIsOpen}
                        loadedImages={loadedImages}
                        choosingImage={choosingImage}
                        actions={actions} />
  )
}

NavigationEditor.propTypes = {
  navigation:       PropTypes.object.isRequired,
  parent:           PropTypes.object.isRequired,
  childTypes:       PropTypes.array.isRequired,
  selectablePages:  PropTypes.array.isRequired,
  modalIsOpen:      PropTypes.bool.isRequired,
  loadedImages:     PropTypes.object.isRequired,
  choosingImage:    PropTypes.bool.isRequired,
  actions:          PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  navigation:       state.navigationState,
  parent:           state.parent,
  childTypes:       state.childTypes,
  selectablePages:  state.selectablePages,
  modalIsOpen:      state.modalIsOpen,
  loadedImages:     state.loadedImages,
  choosingImage:    state.choosingImage
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(NavigationActions, dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(NavigationEditor);
