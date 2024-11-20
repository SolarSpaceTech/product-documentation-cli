import { doIdAction } from "../../../core/actions/generate-available-id";
import { Command } from "../../interfaces/command.interface";
import chalk from "chalk";
import {generatePdfDoc} from "../../../core/actions/generate-pdf-doc";

export const pdfCommand: Command.Model = {
    id: 'pdf',
    name: 'Сгенерировать документацию в PDF',
    isAvailable: true,
    async run() {
        generatePdfDoc();
    },
}
