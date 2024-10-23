import { doIdAction } from "../../../core/actions/generate-available-id";
import { Command } from "../../interfaces/command.interface";
import chalk from "chalk";

export const idCommand: Command.Model = {
    id: 'id',
    name: 'Получить доступный ID статьи',
    isAvailable: true,
    async run() {
        const availableId = doIdAction();

        console.log(`Вы можете использовать: ${ chalk.green(availableId) }`);
    },
}
