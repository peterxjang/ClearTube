import Foundation

struct NextResponse: Decodable {
    var playerOverlays: PlayerOverlaysResponse
    struct PlayerOverlaysResponse: Decodable {
        var playerOverlayRenderer: PlayerOverlayRendererResponse
        struct PlayerOverlayRendererResponse: Decodable {
            var endScreen: EndScreenResponse
            struct EndScreenResponse: Decodable {
                var watchNextEndScreenRenderer: WatchNextEndScreenRendererResponse
                struct WatchNextEndScreenRendererResponse: Decodable {
                    var results: [ResultResponse]
                    struct ResultResponse: Decodable {
                        var endScreenVideoRenderer: EndScreenVideoRendererResponse?
                        struct EndScreenVideoRendererResponse: Decodable {
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
                            var shortBylineText: ShortBylineTextResponse
                            struct ShortBylineTextResponse: Decodable {
                                var runs: [RunResponse]
                                struct RunResponse: Decodable {
                                    var text: String
                                    var navigationEndpoint: NavigationEndpointResponse
                                    struct NavigationEndpointResponse: Decodable {
                                        var browseEndpoint: BrowseEndpointResponse
                                        struct BrowseEndpointResponse: Decodable {
                                            var browseId: String
                                        }
                                    }
                                }
                            }
                            var lengthText: LengthTextObject
                            struct LengthTextObject: Decodable {
                                var runs: [RunResponse]
                                struct RunResponse: Decodable {
                                    var text: String
                                }
                            }
                            var lengthInSeconds: Int
                            var shortViewCountText: ShortViewCountTextObject
                            struct ShortViewCountTextObject: Decodable {
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
                        }
                    }
                }
            }
        }
    }
}
