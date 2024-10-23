import { Command } from "../../interfaces/command.interface";

export const settingsCommand: Command.Model = {
    id: 'settings',
    name: 'Настройки',
    isAvailable: true,
    run() {
        console.log('Create new Article action');
    },
}
