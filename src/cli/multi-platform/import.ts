import { platform } from "node:os";

export async function multiplatformImport(path: string): Promise<any> {
    let multiplatformPath = path;
    if (platform() === 'win32') {
        multiplatformPath = `file:\\\\${multiplatformPath}`;
    }
    return import(multiplatformPath);
}
