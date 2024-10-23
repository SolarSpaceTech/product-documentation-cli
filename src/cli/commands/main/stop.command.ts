import { Command } from "../../interfaces/command.interface";
import { displaySettingsActions } from "../settings";

export const stopCommand: Command.Model = {
    id: 'stop',
    name: 'Выйти',
    isAvailable: true,
    async run() {},
}
