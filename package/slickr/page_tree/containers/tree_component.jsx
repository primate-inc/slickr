import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import React, { Component } from 'react';
import SortableTree, { getFlatDataFromTree } from 'react-sortable-tree';
import * as TreeActions from '../actions'

const canDrop = ({ node, nextParent, prevPath, nextPath }) => {
  if(node.treeIndex == 0 || nextParent == null) {
    return false
  } else {
    return true
  }
}
const FollowLink = (path) => {
  window.location.href = path
}
const canDrag = ({ node, path, treeIndex, lowerSiblingCounts }) => {
  if(treeIndex == 0) {
    return false
  } else {
    return true
  }
}
const updateState = (treeData, actions) => {
  actions.updateTree(treeData)
}
const getClasses = (node, depth) => {
  return node.published ? 'published' : 'unpublished'
}
const moveNode = (node, treeData, nextTreeIndex, actions) => {
  const flatData = getFlatDataFromTree({treeData: treeData, getNodeKey: ({ node }) => node.id })
  const prevNode = flatData[nextTreeIndex - 1]
  const currentNode = flatData[nextTreeIndex]
  if(prevNode.parentNode == currentNode.parentNode){
    actions.saveNodePosition(node, currentNode.parentNode.id, prevNode.id)
  } else {
    actions.saveNodePosition(node, currentNode.parentNode.id, null)
  }
}
const Tree = ({store, pages, actions}) => (
  <div style={{height: "100vh"}}>
    <SortableTree
      treeData={pages}
      onMoveNode={
        ({ node, treeData, nextTreeIndex }) =>
         moveNode(node, treeData, nextTreeIndex, actions)
      }
      canDrag={canDrag}
      canDrop={canDrop}
      onChange={ treeData => { updateState(treeData, actions)}}
      generateNodeProps={({ node, path }) => ({
        className: getClasses(node, node.currentDepth),
        buttons: [
          <button onClick={() =>
            FollowLink(node.edit_page_path)
          }>
            <svg className="svg-icon" viewBox="0 0 20 20"><use xlinkHref="#svg-edit"></use></svg>
            Edit
          </button>,
          <button onClick={() =>
            FollowLink(node.add_child_path)
          }>
            <svg className="svg-icon" viewBox="0 0 20 20"><use xlinkHref="#svg-plus"></use></svg>
            Add Child
          </button>,
          <button onClick={() =>
            FollowLink(node.edit_page_path)
          }>
            <svg className="svg-icon" viewBox="0 0 20 20"><use xlinkHref="#svg-delete"></use></svg>
            Remove
          </button>
        ]
      })}
    />
  </div>
)

Tree.propTypes = {
  pages: PropTypes.array.isRequired,
  actions: PropTypes.object.isRequired
}

const mapStateToProps = state => ({
  pages: state.treeState
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(TreeActions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Tree)
