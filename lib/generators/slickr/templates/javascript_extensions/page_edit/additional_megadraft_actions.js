import FaPdf from 'react-icons/lib/fa/file-pdf-o';
import FaArrow from 'react-icons/lib/fa/arrow-right';

const additionalActions = [
  {type: "entity", label: "PDF Link", style: "link", entity: "PDF_LINK", icon: FaPdf},
  {type: "entity", label: "CTA link", style: "link", entity: "CTA_LINK", icon: FaArrow},
]

export default additionalActions
