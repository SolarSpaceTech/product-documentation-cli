import { getSelect } from "../../ui/select";
import { addCommonCommands } from "../common/add-common-commands";
import { articlesCommand } from "./articles.command";
import { sectionsCommand } from "./sections.command";
import { pluginsCommand } from "./plugins.command";

export async function displayMainMenuActions(): Promise<void> {
    while (true) {
        const commands = addCommonCommands([
            articlesCommand,
            sectionsCommand,
            pluginsCommand,
        ]);
        const selectedChoice = await getSelect(commands);
        await selectedChoice.run();
    }

}

