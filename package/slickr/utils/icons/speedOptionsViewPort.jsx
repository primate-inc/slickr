import React from 'react'

const SpeedOptionsViewPort = props => (
  <svg
    className="dropdown__item__icon"
    width={24}
    height={24}
    viewBox="0 0 22 22" {...props}
  >
    <style>{`.st4{fill:#333}.st5{fill:#ccc}`}</style>
    <g id="Layer_1">
      <path
        className="st5"
        d="M13.7 2l.1.2L15.7 4H20v14h-4.3l-1.9 1.8-.1.2H22V2zM8.2 19.8L6.3 18H2V4h4.3l1.9-1.8.1-.2H0v18h8.3z"
      />
      <g>
        <path
          className="st4"
          d="M11 19.8l1.4-1.4 2.8-2.8-1.4-1.4L11 17l-2.8-2.8-1.4 1.4 2.8 2.8zM11 2.2L9.6 3.6 6.8 6.4l1.4 1.4L11 5l2.8 2.8 1.4-1.4-2.8-2.8z"
        />
      </g>
    </g>
  </svg>
)


export default SpeedOptionsViewPort;
