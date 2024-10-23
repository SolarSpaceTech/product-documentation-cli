import { articlesCommand } from "./articles.command";
import { sectionsCommand } from "./sections.command";
import { settingsCommand } from "./settings.command";
import { getSelect } from "../../ui/select";

export async function displayMainMenuActions(): Promise<void> {
    const selectedChoice = await getSelect([
        settingsCommand,
        articlesCommand,
        sectionsCommand,
    ]);

    selectedChoice.run();
}

