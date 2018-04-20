import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import NavigationWrapper from '../components/navigation_wrapper.jsx'
import * as NavigationActions from '../actions'

let _csrf_param = () => {
  return document.getElementsByName("csrf-param")[0].content
}
let _csrf_token = () => {
  return document.getElementsByName("csrf-token")[0].content
}

const NavigationEditor = ({
    navigation, childTypes, modalIsOpen, loadedImages, choosingImage, actions,
    store
}) => {
  return(
    <NavigationWrapper  navigation={navigation}
                        childTypes={childTypes}
                        modalIsOpen={modalIsOpen}
                        loadedImages={loadedImages}
                        choosingImage={choosingImage}
                        actions={actions} />
  )
}

NavigationEditor.propTypes = {
  navigation:     PropTypes.object.isRequired,
  childTypes:     PropTypes.array.isRequired,
  modalIsOpen:    PropTypes.bool.isRequired,
  loadedImages:   PropTypes.object.isRequired,
  choosingImage:  PropTypes.bool.isRequired,
  actions:        PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  navigation:     state.navigationState,
  childTypes:     state.childTypes,
  modalIsOpen:    state.modalIsOpen,
  loadedImages:   state.loadedImages,
  choosingImage:  state.choosingImage
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(NavigationActions, dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(NavigationEditor);
