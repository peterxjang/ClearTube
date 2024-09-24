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
                                        var gridVideoRenderer: GridVideoRendererResponse
                                        struct GridVideoRendererResponse: Decodable {
                                            var videoId: String
                                            var thumbnail: ThumbnailResponse
                                            struct ThumbnailResponse: Decodable {
                                                var thumbnails: [ImageObject]
                                            }
                                            var title: TitleObject
                                            struct TitleObject: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var publishedTimeText: PublishedTimeTextObject
                                            struct PublishedTimeTextObject: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var viewCountText: ViewCountTextObject
                                            struct ViewCountTextObject: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var lengthText: LengthTextObject
                                            struct LengthTextObject: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var shortBylineText: ShortBylineTextResponse
                                            struct ShortBylineTextResponse: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                    var navigationEndpoint: NavigationEndpointResponse
                                                    struct NavigationEndpointResponse: Decodable {
                                                        var browseEndpoint: BrowseEndpointResponse?
                                                        struct BrowseEndpointResponse: Decodable {
                                                            var browseId: String
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
            }
        }
    }
}
