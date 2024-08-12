import {createTypeStrategy} from "megadraft";
import pdfLinkComponent from "./decorators/pdf_link_component.jsx";

const additionalDecorators = [
  {
    strategy: createTypeStrategy("PDF_LINK"),
    component: pdfLinkComponent,
  }
]

export default additionalDecorators
