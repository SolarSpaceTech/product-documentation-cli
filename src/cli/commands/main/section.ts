import { Command } from "../../interfaces/command.interface";
import { CliModel } from "../../models/cli.model";

export const sectionCommand: Command.Model = {
    id: CliModel.MainCommand.SECTION,
    name: 'Create new Section',
    run() {
        console.log('Create new Section action');
    },
}
