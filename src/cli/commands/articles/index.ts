import { idCommand } from "./id.command";
import { addCommonCommands } from "../common/add-common-commands";
import { getSelect } from "../../ui/select";

export async function displayArticleActions(): Promise<void> {
    const commands = addCommonCommands([idCommand]);
    const selectedChoice = await getSelect(commands);

    return selectedChoice.run();
}

