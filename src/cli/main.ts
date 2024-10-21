import { initDocumentation } from "../core/init";
import { mainActions } from "./commands/main";
import { createPromptModule } from "inquirer";

async function main() {
    initDocumentation();
    const prompt = createPromptModule();
    const answer = await prompt([
        {
            type: 'list',
            name: 'action',
            message: 'What do you want to do?',
            choices: mainActions.map(({ id, name, isAvailable }) => ({
                value: id,
                name,
                disabled: !isAvailable,
            })),
        },
    ]);
    mainActions
        .find(({ id }) => answer.action === id)
        ?.run();
}

main();
