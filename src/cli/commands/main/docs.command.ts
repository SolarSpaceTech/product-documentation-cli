import { Command } from "../../interfaces/command.interface";
import { displayDocActions } from "../docs";

export const docsCommand: Command.Model = {
    id: 'docs',
    name: 'Документация',
    isAvailable: true,
    async run() {
        return displayDocActions();
    },
}
