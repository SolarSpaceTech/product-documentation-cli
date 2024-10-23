import { Command } from "../../interfaces/command.interface";

export const sectionsCommand: Command.Model = {
    id: 'sections',
    name: 'Секции',
    isAvailable: false,
    run() {
        console.log('Create new Section action');
    },
}