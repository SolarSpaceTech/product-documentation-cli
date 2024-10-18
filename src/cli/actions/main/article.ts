import { Command } from "../../interfaces/command.interface";
import { CliModel } from "../../models/cli.model";

export const articleCommand: Command.Model = {
    id: CliModel.MainCommand.ARTICLE,
    name: 'Create new Article',
    run() {
        console.log('Create new Article action');
    },
}
