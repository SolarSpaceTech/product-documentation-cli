export namespace DocumentationModel {
    export type Type = Article | Section | Language;

    export enum ElementType {
        ARTICLE = 'article',
        SECTION = 'section',
        LANGUAGE = 'language',
    }

    export interface Article extends ArticleMetaProperties {
        type: ElementType.ARTICLE;
        link: string;
        content: string;
    }

    export interface Section extends SectionMetaProperties {
        type: ElementType.SECTION;
        link: string;
    }

    export interface Language extends LanguageMetaProperties {
        type: ElementType.LANGUAGE;
        link: string;
    }

    export interface ArticleMetaProperties {
        id: number;
        title: string;
        displayName: string;
        order: number;
        published?: boolean;

        historyName: string;
        historyDescription: string;

        category?: string;
        categoryName?: string;

        categoryDescription?: string;
        categoryOrder?: number;
        categoryIcon?: string;

        headerName?: string;
        headerOrder?: number;

        footerName?: string;
        footerOrder?: number;
    }

    export interface SectionMetaProperties {
        displayName: string;
        order: number;
        published?: boolean;
    }

    export interface LanguageMetaProperties {
        displayName: string;
        order: number;
        categories: string[];
        published?: boolean;
    }
}
