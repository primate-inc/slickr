import {MegadraftIcons} from "megadraft";
import {
  DEFAULT_DISPLAY_OPTIONS,
  DEFAULT_DISPLAY_KEY
} from "./plugin/defaults";

const defaults = {
  defaultDisplay: DEFAULT_DISPLAY_KEY,
  displayOptions: DEFAULT_DISPLAY_OPTIONS
};

const ImageWidgetConfig = () => ({
  standardDisplayOptions: {
    ...defaults,
    displayOptions: [
      {"key": "l_limit", "classname": "normal_img-layout", "icon": MegadraftIcons.MediaMediumIcon, "label": "NORMAL"},
      {"key": "m_fit", "classname": "float-left_img-layout", "icon": MegadraftIcons.MediaSmallIcon, "label": "FlOAT LEFT"},//m_fit needs work, since there cant be two m_limits
      {"key": "m_limit", "classname": "float-right_img-layout", "icon": MegadraftIcons.MediaSmallIcon, "label": "FlOAT RIGHT"},
      {"key": "xxl_fit", "classname": "cover_img-layout", "icon": MegadraftIcons.MediaBigIcon, "label": "COVER"},
      {"key": "xxl_fill", "classname": "letter-box_img-layout", "icon": MegadraftIcons.MediaBigIcon, "label": "LETTER BOX"},
      {"key": "xl_limit", "classname": "larger_img-layout", "icon": MegadraftIcons.MediaBigIcon, "label": "LARGE"},
      {"key": "xxl_limit", "classname": "xl_limit", "icon": MegadraftIcons.MediaBigIcon, "label": "EXTRA LARGE"}
    ],
    defaultDisplay: 'l_limit'
  },
  appearanceOptions: {
    ...defaults,
    displayOptions: [
      {"key": "appearance-none", "icon": MegadraftIcons.MediaSmallIcon, "label": "NONE"},
      {"key": "right", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT RIGHT"},
      {"key": "left", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT LEFT"},
      {"key": "center", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT CENTER"}
    ],
    defaultDisplay: 'appearance-none'
  },
  behaviourOptions: {
    ...defaults,
    optionType: 'Transition',
    displayOptions: [
      {"key": "center", "icon": MegadraftIcons.MediaSmallIcon, "label": "SIT CENTER"},
      {"key": "behaviour-none", "icon": MegadraftIcons.MediaSmallIcon, "label": "NONE"},
      // {"key": "fade-in-left", "icon": MegadraftIcons.MediaSmallIcon, "label": "TRANSITION", speedOptions: [] },
    ],
    defaultDisplay: 'behaviour-none'
  }
});

export default ImageWidgetConfig;