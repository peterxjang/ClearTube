import Foundation

struct BrowseResponse: Decodable {
    var header: HeaderResponse
    struct HeaderResponse: Decodable {
        var pageHeaderRenderer: PageHeaderRendererResponse
        struct PageHeaderRendererResponse: Decodable {
            var pageTitle: String
            var content: ContentResponse
            struct ContentResponse: Decodable {
                var pageHeaderViewModel: PageHeaderViewModelResponse
                struct PageHeaderViewModelResponse: Decodable {
                    var image: ImageResponse
                    struct ImageResponse: Decodable {
                        var decoratedAvatarViewModel: DecoratedAvatarViewModelResponse
                        struct DecoratedAvatarViewModelResponse: Decodable {
                            var avatar: AvatarResponse
                            struct AvatarResponse: Decodable {
                                var avatarViewModel: AvatarViewModelResponse
                                struct AvatarViewModelResponse: Decodable {
                                    var image: ImageResponse
                                    struct ImageResponse: Decodable {
                                        var sources: [ImageObject]
                                    }
                                }
                            }
                        }
                    }
                    var metadata: MetadataResponse
                    struct MetadataResponse: Decodable {
                        var contentMetadataViewModel: ContentMetadataViewModelResponse
                        struct ContentMetadataViewModelResponse: Decodable {
                            var metadataRows: [MetadataRowResponse]
                            struct MetadataRowResponse: Decodable {
                                var metadataParts: [MetadataPartResponse]
                                struct MetadataPartResponse: Decodable {
                                    var text: TextResponse
                                    struct TextResponse: Decodable {
                                        var content: String
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
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
                                        // SHORT
                                        var shortsLockupViewModel: ShortsLockupViewModelResponse?
                                        struct ShortsLockupViewModelResponse: Decodable {
                                            var entityId: String
                                            var thumbnail: ThumbnailResponse
                                            struct ThumbnailResponse: Decodable {
                                                var sources: [ImageObject]
                                            }
                                            var onTap: OnTapResponse
                                            struct OnTapResponse: Decodable {
                                                var innertubeCommand: InnertubeCommandResponse
                                                struct InnertubeCommandResponse: Decodable {
                                                    var reelWatchEndpoint: ReelWatchEndpointResponse
                                                    struct ReelWatchEndpointResponse: Decodable {
                                                        var videoId: String
                                                    }
                                                }
                                            }
                                            var overlayMetadata: OverlayMetadataResponse
                                            struct OverlayMetadataResponse: Decodable {
                                                var primaryText: PrimaryTextResponse
                                                struct PrimaryTextResponse: Decodable {
                                                    var content: String
                                                }
                                                var secondaryText: SecondaryTextResponse
                                                struct SecondaryTextResponse: Decodable {
                                                    var content: String
                                                }
                                            }
                                        }
                                        // VIDEO
                                        var videoRenderer: VideoRendererResponse?
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
