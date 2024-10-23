export namespace Command {
    export interface Model {
        id: string;
        name: string;
        run(...args: any): void;
        isAvailable: boolean;
        description?: string;
    }
}
