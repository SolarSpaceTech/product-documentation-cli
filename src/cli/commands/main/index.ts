import { articlesCommand } from "./articles.command";
import { sectionsCommand } from "./sections.command";
import { settingsCommand } from "./settings.command";
import { getSelect } from "../../ui/select";
import {stopCommand} from "./stop.command";

export async function displayMainMenuActions(): Promise<void> {
    while (true) {
        const selectedChoice = await getSelect([
            settingsCommand,
            articlesCommand,
            sectionsCommand,
            stopCommand,
        ]);

        if (selectedChoice.id === 'stop') {
            break;
        }
        await selectedChoice.run();
    }

}

