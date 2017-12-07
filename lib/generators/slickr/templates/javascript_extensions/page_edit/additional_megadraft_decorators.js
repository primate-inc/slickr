import {createTypeStrategy} from "megadraft";
import adminLinkComponent from "./decorators/admin_link_component";

const additionalDecorators = [
  {
    strategy: createTypeStrategy("ADMIN_LINK"),
    component: adminLinkComponent,
  }
]

export default additionalDecorators
