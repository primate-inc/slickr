// import draftToHtml from 'draftjs-to-html';
import {editorStateToJSON} from "megadraft";
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import PageWrapper from '../components/page_wrapper.jsx';
import * as PageActions from '../actions';
import * as MainAppPageActions from 'slickr_extensions/page_edit/actions/additional_actions.js';
import mainAppPropTypes from 'slickr_extensions/page_edit/containers/additional_prop_types.js';

let _csrf_param = () => { return document.getElementsByName("csrf-param")[0].content }
let _csrf_token = () => { return document.getElementsByName("csrf-token")[0].content }

const MyEditor = ({ schedulingActive, pageLayouts, store, page, active_tab,
                    actions, modalIsOpen, editorState, loadedImages,
                    choosingPageHeaderImage }) => {
  return(
    <PageWrapper pageLayouts={pageLayouts}
                 page={page}
                 actions={actions}
                 schedulingActive={schedulingActive}
                 editorState={editorState}
                 modalIsOpen={modalIsOpen}
                 loadedImages={loadedImages}
                 active_tab={active_tab}
                 choosingPageHeaderImage={choosingPageHeaderImage} />
  )
}

const slickrPropTypes = {
  page: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired,
  modalIsOpen: PropTypes.bool.isRequired,
  loadedImages: PropTypes.object.isRequired,
  editorState: PropTypes.object.isRequired,
  pageLayouts: PropTypes.array.isRequired,
  choosingPageHeaderImage: PropTypes.bool.isRequired
}
const mergedPropTypes = Object.assign(slickrPropTypes, mainAppPropTypes);

MyEditor.propTypes = mergedPropTypes

const mapStateToProps = state => ({
  page: state.pageState,
  pageLayouts: state.pageLayouts,
  active_tab: state.activeTab,
  modalIsOpen: state.modalIsOpen,
  loadedImages: state.loadedImages,
  schedulingActive: state.schedulingActive,
  editorState: state.editorState,
  choosingPageHeaderImage: state.choosingPageHeaderImage
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(
    Object.assign({}, PageActions, MainAppPageActions), dispatch
  )
})

export default connect(mapStateToProps, mapDispatchToProps)(MyEditor);
