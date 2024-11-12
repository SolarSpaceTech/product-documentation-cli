import { Command } from "../../interfaces/command.interface";

export const exitCommand: Command.Model = {
    id: 'stop',
    name: 'Выйти',
    async run() {
        process.exit(0);
    },
    isAvailable: true,
}
