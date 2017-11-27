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
  options: options.standardDisplayOptions,
  ...options.customOptions
});

export default ImagePlugin;
