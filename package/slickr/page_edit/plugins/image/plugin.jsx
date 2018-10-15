/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

import ImageButtonContainer from "./ImageButtonContainer.jsx";
import ImageBlock from "./ImageBlock.jsx";

const ImagePlugin = (options) => ({
  title: "Image",
  type: "image",
  buttonComponent: ImageButtonContainer,
  blockComponent: ImageBlock,
  layoutOptions: options.standardDisplayOptions,
  appearanceOptions: options.appearanceOptions,
  behaviourOptions: options.behaviourOptions,
  ...options.customOptions
});

export default ImagePlugin;
