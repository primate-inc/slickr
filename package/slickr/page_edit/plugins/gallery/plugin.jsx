
import GalleryButton from "./GalleryButton.jsx";
import GalleryBlockContainer from "./GalleryBlockContainer.jsx";
import constants from "./constants";

export default {
  title: 'Gallery',
  type: constants.PLUGIN_TYPE,
  buttonComponent: GalleryButton,
  blockComponent: GalleryBlockContainer,
  options: {
    displayOptions: [],
    defaultDisplay: null
  }
};
