import { Command } from "../../interfaces/command.interface";
import chalk from "chalk";

export const rootDirCommand: Command.Model = {
    id: 'rootDir',
    name: 'Выбрать корневую директорию',
    isAvailable: true,
    async run() {
        console.log(chalk.gray('Выбор корневой директории ещё не реализован'));
    },
}
