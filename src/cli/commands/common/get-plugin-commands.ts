import { readdirSync, statSync } from "node:fs";
import {join, normalize} from "node:path";
import { Command } from "../../interfaces/command.interface";
import { multiplatformImport } from "../../multi-platform/import";
import process from "process";

export async function getPluginCommands(): Promise<Command.Model[]> {
    let dirItems: string[] = [];
    const currentDir = join(process.cwd(), normalize(process.env.PD_PLUGINS_DIR ?? "plugins"));
    try {
        dirItems = readdirSync(currentDir);
    } catch {
        console.error('Не найдена директория "plugins"');
    }
    const plugins: Command.Model[] = [];
    for (const dirItem of dirItems) {
        const currentPluginDir = join(currentDir, dirItem);
        const stat = statSync(currentPluginDir);
        if (stat.isFile()) {
            continue;
        }
        const pluginDirItems = readdirSync(currentPluginDir);
        const mainPluginFileName = pluginDirItems.find((pluginDirItem) => pluginDirItem.startsWith('main.'));
        if (!mainPluginFileName) {
            continue;
        }
        let mainPluginFilePath = join(currentPluginDir, mainPluginFileName);
        const { plugin } = await multiplatformImport(mainPluginFilePath);
        if (plugin) {
            plugins.push(plugin);
        }
    }
    return plugins;
}
