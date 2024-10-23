import { getSelect } from "../../ui/select";
import { rootDirCommand } from "./root-dir.command";

export async function displaySettingsActions(): Promise<void> {
    const selectedChoice = await getSelect([
        rootDirCommand,
    ]);

    selectedChoice.run();
}

