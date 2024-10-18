import { doIdAction } from "../../../core/actions/generate-available-id";
import { Command } from "../../interfaces/command.interface";
import { CliModel } from "../../models/cli.model";

export const idCommand: Command.Model = {
    id: CliModel.MainCommand.ID,
    name: 'Get available ID for article',
    isAvailable: true,
    run() {
        const availableId = doIdAction();
        console.log(`You can use ID: ${ availableId }`);
    },
}
