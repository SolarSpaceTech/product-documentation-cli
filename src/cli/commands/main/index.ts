import { articlesCommand } from "./articles";
import { sectionsCommand } from "./sections";
import { settingsCommand } from "./settings";
import { getSelect } from "../../ui/select";

export async function displayMainMenuActions(): Promise<void> {
    const selectedChoice = await getSelect([
        settingsCommand,
        articlesCommand,
        sectionsCommand,
    ]);

    selectedChoice.run();
}

