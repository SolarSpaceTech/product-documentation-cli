import { updateSettings } from "../settings";

export function updateRootDirSettingsAction(rootDir: string): void {
    updateSettings({ rootDir });
}
