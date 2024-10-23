import { idCommand } from "./id.command";
import { getSelect } from "../../ui/select";

export async function displayArticleActions(): Promise<void> {
    const selectedChoice = await getSelect([
        idCommand,
    ]);

    selectedChoice.run();
}

