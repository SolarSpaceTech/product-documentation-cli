import { getDocumentation } from "../documentation";
import {DocumentationModel} from "../models/documentation.model";

export function doIdAction(): number {
    const documentation = getDocumentation();
    const ids = documentation.content
        .filter((documentationItem) =>
            documentationItem.type === DocumentationModel.ElementType.ARTICLE && documentationItem.id
        )
        .map((documentationItem) => (documentationItem as DocumentationModel.Article).id);
    const maxId = Math.max(...ids);
    return maxId + 1;
}
