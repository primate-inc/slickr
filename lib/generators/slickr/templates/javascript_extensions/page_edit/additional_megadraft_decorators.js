import {createTypeStrategy} from "megadraft";
import pdfLinkComponent from "./decorators/pdf_link_component.jsx";
import ctaLinkComponent from "./decorators/cta_link_component.jsx";

const additionalDecorators = [
  {
    strategy: createTypeStrategy("PDF_LINK"),
    component: pdfLinkComponent,
  },
  {
    strategy: createTypeStrategy("CTA_LINK"),
    component: ctaLinkComponent,
  },
]

export default additionalDecorators
