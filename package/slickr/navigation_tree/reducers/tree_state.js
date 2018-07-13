import SortableTree, { getFlatDataFromTree, getTreeFromFlatData } from 'react-sortable-tree';

const treeState = (state = {}, action) => {
  switch(action.type) {
    case 'UPDATE_TREE':
      return action.payload
    case 'NAVIGATION_POSITION_UPDATED':
      // flatten the state tree
      const flatData = getFlatDataFromTree({
        treeData: state,
        getNodeKey: ({ node }) => node.id
      })

      // Change the parent_id and ancestor_ids of the node that was changed
      // to the values returned by the server
      let nodes = flatData.map(data => data.node);
      nodes[0].parent_id = null
      let nodeToUpdate = nodes.find(node => node.id === action.payload.id);
      nodeToUpdate.ancestor_ids = action.payload.ancestor_ids;
      nodeToUpdate.parent_id = action.payload.parent_id;

      // Convert the flat data back to a tree and update stae with that
      const treeData = getTreeFromFlatData({
        flatData: nodes,
        getParentKey: node => node.parent_id,
        rootKey: null
      });
      return treeData;
    default:
      return state;
  }
}

export default treeState
