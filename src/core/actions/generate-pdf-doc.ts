import {getDocumentation} from "../documentation";
import {DocumentationModel} from "../models/documentation.model";

export function generatePdfDoc() {
    const documentation = getDocumentation();
    const article = documentation.contentMapById.get(250);
    if (article?.type === DocumentationModel.ElementType.ARTICLE) {
        console.log(article.content)
    }
}
