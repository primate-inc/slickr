/*
 * Copyright (c) 2016, Globo.com (https://github.com/globocom)
 *
 * License: MIT
 */

// import icons from "../../icons";
// import { MediaBigIcon, MediaMediumIcon, MediaSmallIcon } from "../../icons";//didn't work
import MediaBigIcon from "../../icons/mediaBig";
import MediaMediumIcon from "../../icons/mediaMedium";
import MediaSmallIcon from "../../icons/mediaSmall";

export const DEFAULT_DISPLAY_OPTIONS = [
  { key: "small", icon: MediaSmallIcon, label: "SMALL" },
  { key: "medium", icon: MediaMediumIcon, label: "MEDIUM" },
  { key: "big", icon: MediaBigIcon, label: "BIG" }
];

export const DEFAULT_DISPLAY_KEY = "medium";
