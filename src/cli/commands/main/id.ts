import { doIdAction } from "../../../core/actions/generate-available-id";
import { Command } from "../../interfaces/command.interface";
import { CliModel } from "../../models/cli.model";
import chalk from "chalk";

export const idCommand: Command.Model = {
    id: CliModel.MainCommand.ID,
    name: 'Get available ID for article',
    isAvailable: true,
    async run() {
        const availableId = doIdAction();

        console.log(`You can use ID: ${ chalk.green(availableId) }`);
    },
}
