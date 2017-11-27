import React from 'react';
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as PageActions from '../../actions'
import cx from 'classnames';
import store from '../../../packs/page_edit.jsx'
import ImageButton from "./ImageButton.jsx";

const ImageButtonContainer = ({store, modalIsOpen, actions, loadedImages, editorState}) => (
      <div>
        <ImageButton modalIsOpen={modalIsOpen}
                     actions={actions}
                     loadedImages={loadedImages}
                     editorState={editorState}
        />
      </div>
    )

ImageButtonContainer.propTypes = {
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.array.isRequired,
  editorState: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  active_tab: state.activeTab,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  editorState: state.editorState
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(PageActions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ImageButtonContainer)
