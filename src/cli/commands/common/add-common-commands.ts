import { exitCommand } from "./exit.command";
import { Command } from "../../interfaces/command.interface";

export function addCommonCommands(commands: Command.Model[]): Command.Model[] {
    return [
        ...commands,
        exitCommand,
    ];
}
