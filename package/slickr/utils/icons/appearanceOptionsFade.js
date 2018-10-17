import React from 'react'

const appearanceOptionsFade = props => (
  <svg
    className="dropdown__item__icon"
    width={24}
    height={24}
    version={1.1}
    id="Layer_1"
    x={0}
    y={0}
    viewBox="0 0 22 22"
    xmlSpace="preserve"
    {...props}
  >
    <style />
    <path transform="rotate(-90 19 11)" fill="#333" d="M10 10h18v2H10z" />
    <path transform="rotate(-90 15 11)" fill="#595959" d="M6 10h18v2H6z" />
    <path transform="rotate(-90 11 11)" fill="#7f7f7f" d="M2 10h18v2H2z" />
    <path transform="rotate(-90 7 11)" fill="#a5a5a5" d="M-2 10h18v2H-2z" />
    <path transform="rotate(-90 3 11)" fill="#ccc" d="M-6 10h18v2H-6z" />
  </svg>
)

export default appearanceOptionsFade;
