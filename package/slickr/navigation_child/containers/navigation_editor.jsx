import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import NavigationWrapper from '../components/navigation_wrapper.jsx'
import * as NavigationActions from '../actions'
import * as MediaGalleryActions from '../../media_gallery/actions';

const NavigationEditor = ({
    navigation, parent, rootNav, childTypes, selectablePages, modalIsOpen,
    loadedImages, choosingNavImage, actions, store
}) => {
  return(
    <NavigationWrapper  navigation={navigation}
                        parent={parent}
                        rootNav={rootNav}
                        childTypes={childTypes}
                        selectablePages={selectablePages}
                        modalIsOpen={modalIsOpen}
                        loadedImages={loadedImages}
                        choosingNavImage={choosingNavImage}
                        actions={actions} />
  )
}

NavigationEditor.propTypes = {
  navigation:       PropTypes.object.isRequired,
  parent:           PropTypes.object.isRequired,
  rootNav:          PropTypes.object.isRequired,
  childTypes:       PropTypes.array.isRequired,
  selectablePages:  PropTypes.array.isRequired,
  modalIsOpen:      PropTypes.bool.isRequired,
  loadedImages:     PropTypes.object.isRequired,
  choosingNavImage: PropTypes.bool.isRequired,
  actions:          PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  navigation:       state.navigationState,
  parent:           state.parent,
  rootNav:          state.rootNav,
  childTypes:       state.childTypes,
  selectablePages:  state.selectablePages,
  modalIsOpen:      state.modalIsOpen,
  loadedImages:     state.loadedImages,
  choosingNavImage: state.choosingNavImage
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(
    Object.assign({}, NavigationActions, MediaGalleryActions), dispatch
  )
})

export default connect(mapStateToProps, mapDispatchToProps)(NavigationEditor);
