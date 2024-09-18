import Foundation

struct NextResponse: Decodable {
    var contents: ContentsResponse
    struct ContentsResponse: Decodable {
        var singleColumnWatchNextResults: SingleColumnWatchNextResultsResponse
        struct SingleColumnWatchNextResultsResponse: Decodable {
            var results: ResultsResponse
            struct ResultsResponse: Decodable {
                var results: ResultsResponse
                struct ResultsResponse: Decodable {
                    var contents: [ContentResponse]
                    struct ContentResponse: Decodable {
                        var shelfRenderer: ShelfRendererResponse?
                        struct ShelfRendererResponse: Decodable {
                            var content: ContentResponse
                            struct ContentResponse: Decodable {
                                var horizontalListRenderer: HorizontalListRendererResponse
                                struct HorizontalListRendererResponse: Decodable {
                                    var items: [ItemResponse]
                                    struct ItemResponse: Decodable {
                                        var gridVideoRenderer: GridVideoRendererResponse?
                                        struct GridVideoRendererResponse: Decodable {
                                            var videoId: String
                                            var thumbnail: ThumbnailResponse
                                            struct ThumbnailResponse: Decodable {
                                                var thumbnails: [ImageObject]
                                            }
                                            var title: RunsTextResponse
                                            struct RunsTextResponse: Decodable {
                                                var runs: [RunsResponse]
                                                struct RunsResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var publishedTimeText: RunsTextResponse
                                            var viewCountText: RunsTextResponse
                                            var lengthText: RunsTextResponse
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
