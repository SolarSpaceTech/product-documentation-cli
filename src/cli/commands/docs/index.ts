import { pdfCommand } from "./pdf.command";
import { addCommonCommands } from "../common/add-common-commands";
import { getSelect } from "../../ui/select";

export async function displayDocActions(): Promise<void> {
    const commands = addCommonCommands([pdfCommand]);
    const selectedChoice = await getSelect(commands);

    return selectedChoice.run();
}

