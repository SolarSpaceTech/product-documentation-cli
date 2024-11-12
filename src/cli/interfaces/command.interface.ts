export namespace Command {
    export interface Model {
        id: string;
        name: string;
        run(...args: any): Promise<any>;
        isAvailable: boolean;
        description?: string;
    }
}
