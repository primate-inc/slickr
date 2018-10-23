import {MegadraftIcons} from "megadraft";
import {
  DEFAULT_DISPLAY_OPTIONS,
  DEFAULT_DISPLAY_KEY
} from "./plugin/defaults";

const defaults = {
  defaultDisplay: DEFAULT_DISPLAY_KEY,
  displayOptions: DEFAULT_DISPLAY_OPTIONS
};

import dropDownIcons from "../../utils/dropDownIcons"

//Example icon import Icons.AppearanceOptionsNone

const ImageWidgetConfig = () => ({
  standardDisplayOptions: {
    ...defaults,
    displayOptions: [
      {"key": "l_limit", "classname": "normal_img-layout", "icon": dropDownIcons.LayoutOptionsNormal, "label": "NORMAL"},
      {"key": "m_fit", "classname": "float-left_img-layout", "icon": dropDownIcons.LayoutOptionsFloatLeft, "label": "FlOAT LEFT"},//m_fit needs work, since there cant be two m_limits
      {"key": "m_limit", "classname": "float-right_img-layout", "icon": dropDownIcons.LayoutOptionsFloatRight, "label": "FlOAT RIGHT"},
      {"key": "xxl_fit", "classname": "cover_img-layout", "icon": dropDownIcons.LayoutOptionsCover, "label": "COVER"},
      {"key": "xxl_fit", "classname": "letter-box_img-layout", "icon": dropDownIcons.LayoutOptionsLetterbox, "label": "LETTER BOX"},
      {"key": "xl_limit", "classname": "large_img-layout", "icon": dropDownIcons.LayoutOptionsLarge, "label": "LARGE"}
    ],
    defaultDisplay: 'l_limit'
  },
  appearanceOptions: {
    ...defaults,
    displayOptions: [
      {"key": "appearance-none", "icon": dropDownIcons.AppearanceOptionsNone, "label": "NONE"},
      {"key": "fade-in", "icon": dropDownIcons.AppearanceOptionsFade, "label": "FADE IN"},
      {"key": "slide-in_from_left", "icon": dropDownIcons.AppearanceOptionsLeftRight, "label": "FADE IN"},
      {"key": "slide-in_from_right", "icon": dropDownIcons.AppearanceOptionsRightLeft, "label": "SLIDE IN"},
      {"key": "slide-in_from_top", "icon": dropDownIcons.AppearanceOptionsTopBottom, "label": "SLIDE IN FROM TOP"},
      {"key": "slide-in_from_bottom", "icon": dropDownIcons.AppearanceOptionsBottomTop, "label": "SLIDE IN FROM BOTTOM"}
    ],
    defaultDisplay: 'appearance-none'
  },
  behaviourOptions: {
    ...defaults,
    optionType: 'Transition',
    displayOptions: [
      {"key": "slow-speed", "icon": dropDownIcons.SpeedOptionsSlow, "label": "SLOW SPEED"},
      {"key": "normal-speed", "icon": dropDownIcons.SpeedOptionsMedium, "label": "NORMAL SPEED"},
      {"key": "fast-speed", "icon": dropDownIcons.SpeedOptionsFast, "label": "FAST SPEED"},
      {"key": "view-port", "icon": dropDownIcons.SpeedOptionsViewPort, "label": "VIEW PORT"}
    ],
    defaultDisplay: 'normal-speed'
  }
});

export default ImageWidgetConfig;