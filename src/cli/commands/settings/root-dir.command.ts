import { Command } from "../../interfaces/command.interface";
import { updateRootDirSettingsAction } from "../../../core/actions/update-root-dir-settings";

export const rootDirCommand: Command.Model = {
    id: 'rootDir',
    name: 'Выбрать корневую директорию',
    isAvailable: true,
    async run() {
        updateRootDirSettingsAction('test');
    },
}
