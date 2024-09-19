import Foundation

struct BrowseResponse: Decodable {
    var contents: ContentsResponse
    struct ContentsResponse: Decodable {
        var twoColumnBrowseResultsRenderer: TwoColumnBrowseResultsRendererResponse
        struct TwoColumnBrowseResultsRendererResponse: Decodable {
            var tabs: [TabResponse]
            struct TabResponse: Decodable {
                var tabRenderer: TabRendererResponse?
                struct TabRendererResponse: Decodable {
                    var endpoint: EndpointResponse
                    struct EndpointResponse: Decodable {
                        var browseEndpoint: BrowseEndpointResponse
                        struct BrowseEndpointResponse: Decodable {
                            var browseId: String
                            var params: String
                            var canonicalBaseUrl: String
                        }
                    }
                    var title: String
                    var content: ContentResponse?
                    struct ContentResponse: Decodable {
                        var richGridRenderer: RichGridRendererResponse?
                        struct RichGridRendererResponse: Decodable {
                            var contents: [ContentResponse]
                            struct ContentResponse: Decodable {
                                var richItemRenderer: RichItemRendererResponse?
                                struct RichItemRendererResponse: Decodable {
                                    var content: ContentResponse
                                    struct ContentResponse: Decodable {
                                        var videoRenderer: VideoRendererResponse
                                        struct VideoRendererResponse: Decodable {
                                            var videoId: String
                                            var thumbnail: ThumbnailResponse
                                            struct ThumbnailResponse: Decodable {
                                                var thumbnails: [ImageObject]
                                            }
                                            var title: RunsResponse
                                            struct RunsResponse: Decodable {
                                                var runs: [RunResponse]
                                                struct RunResponse: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var descriptionSnippet: RunsResponse?
                                            var publishedTimeText: SimpleTextResponse
                                            struct SimpleTextResponse: Decodable {
                                                var simpleText: String
                                            }
                                            var lengthText: SimpleTextResponse
                                            var viewCountText: SimpleTextResponse
                                            var navigationEndpoint: NavigationEndpointResponse
                                            struct NavigationEndpointResponse: Decodable {
                                                var watchEndpoint: WatchEndpointDecodable
                                                struct WatchEndpointDecodable: Decodable {
                                                    var videoId: String
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
