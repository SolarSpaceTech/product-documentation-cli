import { Command } from "../../interfaces/command.interface";
import { displaySettingsActions } from "../settings";

export const settingsCommand: Command.Model = {
    id: 'settings',
    name: 'Настройки',
    isAvailable: true,
    run() {
        displaySettingsActions();
    },
}
