import { readdirSync } from "node:fs";
import { resolve } from "node:path";
import { Command } from "../../interfaces/command.interface";
import { getSelect } from "../../ui/select";
import { addCommonCommands } from "../common/add-common-commands";
import { getPluginCommands } from "../common/get-plugin-commands";

export const pluginsCommand: Command.Model = {
    id: 'plugins',
    name: 'Плагины',
    isAvailable: true,
    async run() {
        const plugins = await getPluginCommands();
        const commands = addCommonCommands(plugins);
        const selectedChoice = await getSelect(commands);

        return selectedChoice.run();
    },
}

async function getPlugins(): Promise<Command.Model[]> {
    const currentDir = process.cwd();
    let dirItems: string[] = [];
    try {
        dirItems = readdirSync('plugins');
    } catch {
        console.error('Не найдена директория "plugins"');
    }
    const plugins: Command.Model[] = [];
    for (const dirItem of dirItems) {
        const currentPluginFile = resolve(currentDir, 'plugins', dirItem);
        const { plugin } = await import(currentPluginFile);
        if (plugin) {
            plugins.push({
                ...plugin,
            });
        }
    }
    return plugins;
}
