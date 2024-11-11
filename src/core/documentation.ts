import frontMatter, { FrontMatterResult } from 'front-matter';

import { extname, join, dirname, sep, normalize } from 'node:path';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import process from 'process';

import { DocumentationModel } from './models/documentation.model';

export function getDocumentation(): Documentation {
    return new Documentation();
}

export class Documentation {
    private readonly contentDir: string;
    public content: DocumentationModel.Type[] = [];
    public contentMapByPath: Map<string, DocumentationModel.Type> = new Map();
    public contentMapById: Map<number, DocumentationModel.Type> = new Map();

    constructor() {
        this.contentDir = join(process.cwd(), normalize(process.env.PD_CONTENT_DIR ?? "content"));
        this.traverseDirectory(this.contentDir);
        this.content.forEach((contentItem) => {
            this.contentMapByPath.set(contentItem.link?.slice?.(1), contentItem);
            if (contentItem.type === DocumentationModel.ElementType.ARTICLE) {
                this.contentMapById.set(contentItem.id, contentItem);
            }
        });
    }

    public getContentByLanguage(language: string): DocumentationModel.Type[] {
        const prefix = `${sep}${language}${sep}`;
        return this.content.filter((documentationItem) => documentationItem.link.startsWith(prefix));
    }

    private traverseDirectory(dir: string) {
        const files = readdirSync(dir);

        for (const file of files) {
            const fullPath = join(dir, file);
            const stat = statSync(fullPath);

            if (stat.isDirectory()) {
                this.traverseDirectory(fullPath);
            }

            if (!stat.isFile() || extname(file) !== '.md') {
                continue;
            }

            if (file === 'metadata.md') {
                this.processMarkdownSection(fullPath);
            }
            this.processMarkdownArticle(fullPath)
        }

    }

    private processMarkdownArticle(filePath: string): void {
        const file = this.getFile<DocumentationModel.ArticleMetaProperties>(filePath);

        if (!file) {
            return;
        }

        const [path] = filePath.split('.');
        this.content.push({
            type: DocumentationModel.ElementType.ARTICLE,
            link: path.replace(this.contentDir, ''),
            content: file.body,
            ...file.attributes,
        });
    }

    private processMarkdownSection(filePath: string): void {
        const file = this.getFile<DocumentationModel.SectionMetaProperties>(filePath);

        if (!file) {
            return;
        }
        this.content.push({
            type: DocumentationModel.ElementType.SECTION,
            link: dirname(filePath).replace(this.contentDir, ''),
            ...file.attributes,
        });
    }

    private getFile<T>(path: string): void | FrontMatterResult<T> {
        const content = readFileSync(path, 'utf8');
        if (content) {
            return frontMatter<T>(content);
        }
    }
}
