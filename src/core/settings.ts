import { readFileSync, writeFileSync } from "node:fs";
import { SettingsModel } from "./models/settings.model";

const SETTINGS_FILE_NAME = "pdcli-settings.json";
let settings: Partial<SettingsModel>;

export function getSettings(): Partial<SettingsModel> {
    if (!settings) {
        initSettings();
    }
    return settings;
}

export function initSettings(): void {
    try {
        const settingsString = readFileSync(SETTINGS_FILE_NAME, "utf8");
        settings = JSON.parse(settingsString);
    } catch {
        updateSettings({});
    }
}

export function updateSettings(newSettings: Partial<SettingsModel>): void {
    settings = {
        ...(settings ?? {}),
        ...newSettings,
    };
    writeFileSync(SETTINGS_FILE_NAME, JSON.stringify(settings));
}
