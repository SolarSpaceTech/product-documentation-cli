import { SettingsModel } from "../models/settings.model";
import { getSettings } from "../settings";

export function getSettingsAction(): Partial<SettingsModel> {
    return getSettings();
}
