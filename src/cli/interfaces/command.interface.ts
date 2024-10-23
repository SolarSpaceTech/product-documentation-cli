export namespace Command {
    export interface Model {
        id: string;
        name: string;
        run(...args: any): Promise<void>;
        isAvailable: boolean;
        description?: string;
    }
}
