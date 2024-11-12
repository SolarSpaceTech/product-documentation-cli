import { select } from "@inquirer/prompts";
import { Command } from "../interfaces/command.interface";

export async function getSelect(commands: Command.Model[]): Promise<Command.Model> {
    const commandId = await select({
        message: '',
        choices: commands.map((command) => ({
            name: command.name,
            value: command.id,
            description: command.description ?? "",
            disabled: !command.isAvailable,
            short: "",
        })),
        theme: {
            prefix: "",
            helpMode: "never",
        }
    });
    return commands.find(({ id }) => commandId === id) as Command.Model;
}
