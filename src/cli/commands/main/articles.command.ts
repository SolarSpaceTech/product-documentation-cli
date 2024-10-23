import { Command } from "../../interfaces/command.interface";
import { displayArticleActions } from "../articles";

export const articlesCommand: Command.Model = {
    id: 'articles',
    name: 'Статьи',
    isAvailable: true,
    run() {
        displayArticleActions();
    },
}
