import Foundation

struct Post {

    let meta: Meta
    let slug: String
    let date: Date
    let tags: [String]
    let html: String
    let config: Config
    let templatesUrl: URL
    let outputUrl: URL
    let modificationDate: Date

    func generate() throws {
        let postTemplate = PostTemplate(
            templatesUrl: templatesUrl,
            context: .init(
                meta: meta,
                contents: html,
                date: config.formatter.string(from: date),
                tags: tags
            )
        )

        let indexTemplate = IndexTemplate(
            templatesUrl: templatesUrl,
            context: .init(
                meta: meta,
                contents: try postTemplate.render()
            )
        )

        let htmlUrl =
            outputUrl
            .appendingPathComponent(slug)
            .appendingPathExtension("html")

        try indexTemplate.render().write(
            to: htmlUrl,
            atomically: true,
            encoding: .utf8
        )
    }
}
