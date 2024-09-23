import Foundation

struct BrowseResponse: Decodable {
    var header: HeaderResponse
    struct HeaderResponse: Decodable {
        var playlistHeaderRenderer: PlaylistHeaderRendererResponse?
        struct PlaylistHeaderRendererResponse: Decodable {
            var playlistId: String
            var title: TitleResponse
            struct TitleResponse: Decodable {
                var simpleText: String
            }
            var numVideosText: NumVideosTextResponse
            struct NumVideosTextResponse: Decodable {
                var runs: [RunResponse]
                struct RunResponse: Decodable {
                    var text: String
                }
            }
            var ownerText: OwnerTextResponse
            struct OwnerTextResponse: Decodable {
                var runs: [RunResponse]
                struct RunResponse: Decodable {
                    var text: String
                    var navigationEndpoint: NavigationEndpointResponse
                    struct NavigationEndpointResponse: Decodable {
                        var browseEndpoint: BrowseEndpointResponse
                        struct BrowseEndpointResponse: Decodable {
                            var browseId: String
                            var canonicalBaseUrl: String
                        }
                    }
                }
            }
        }
        var pageHeaderRenderer: PageHeaderRendererResponse?
        struct PageHeaderRendererResponse: Decodable {
            var pageTitle: String
            var content: ContentResponse
            struct ContentResponse: Decodable {
                var pageHeaderViewModel: PageHeaderViewModelResponse
                struct PageHeaderViewModelResponse: Decodable {
                    var image: ImageResponse?
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
                                    var text: TextResponse?
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
                    var endpoint: EndpointResponse?
                    struct EndpointResponse: Decodable {
                        var browseEndpoint: BrowseEndpointResponse
                        struct BrowseEndpointResponse: Decodable {
                            var browseId: String
                            var params: String
                            var canonicalBaseUrl: String
                        }
                    }
                    var title: String?
                    var content: ContentResponse?
                    struct ContentResponse: Decodable {
                        var sectionListRenderer: SectionListRendererResponse?
                        struct SectionListRendererResponse: Decodable {
                            var contents: [ContentResponse]
                            struct ContentResponse: Decodable {
                                var itemSectionRenderer: ItemSectionRendererResponse?
                                struct ItemSectionRendererResponse: Decodable {
                                    var contents: [ContentResponse]
                                    struct ContentResponse: Decodable {
                                        // PLAYLIST
                                        var playlistVideoListRenderer: PlaylistVideoListRendererResponse?
                                        struct PlaylistVideoListRendererResponse: Decodable {
                                            var contents: [ContentResponse]
                                            struct ContentResponse: Decodable {
                                                var playlistVideoRenderer: PlaylistVideoRendererResponse?
                                                struct PlaylistVideoRendererResponse: Decodable {
                                                    var videoId: String
                                                    var thumbnail: ThumbnailResponse
                                                    struct ThumbnailResponse: Decodable {
                                                        var thumbnails: [ImageObject]
                                                    }
                                                    var title: TitleResponse
                                                    struct TitleResponse: Decodable {
                                                        var runs: [RunResponse]
                                                        struct RunResponse: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                    var shortBylineText: ShortBylineText
                                                    struct ShortBylineText: Decodable {
                                                        var runs: [RunResponse]
                                                        struct RunResponse: Decodable {
                                                            var text: String
                                                            var navigationEndpoint: NavigationEndpointResponse
                                                            struct NavigationEndpointResponse: Decodable {
                                                                var browseEndpoint: BrowseEndpointResponse
                                                                struct BrowseEndpointResponse: Decodable {
                                                                    var browseId: String
                                                                    var canonicalBaseUrl: String
                                                                }
                                                            }
                                                        }
                                                    }
                                                    var lengthSeconds: String
                                                    var videoInfo: VideoInfoResponse
                                                    struct VideoInfoResponse: Decodable {
                                                        var runs: [RunResponse]?
                                                        struct RunResponse: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        // VIDEO
                                        var gridRenderer: GridRendererResponse?
                                        struct GridRendererResponse: Decodable {
                                            var items: [ItemResponse]
                                            struct ItemResponse: Decodable {
                                                var gridPlaylistRenderer: GridPlaylistRendererResponse?
                                                struct GridPlaylistRendererResponse: Decodable {
                                                    var playlistId: String
                                                    var thumbnail: ThumbnailResponse
                                                    struct ThumbnailResponse: Decodable {
                                                        var thumbnails: [ImageObject]
                                                    }
                                                    var title: TitleResponse
                                                    struct TitleResponse: Decodable {
                                                        var runs: [RunResponse]
                                                        struct RunResponse: Decodable {
                                                            var text: String
                                                            var navigationEndpoint: NavigationEndpointResponse
                                                            struct NavigationEndpointResponse: Decodable {
                                                                var watchEndpoint: WatchEndpointResponse
                                                                struct WatchEndpointResponse: Decodable {
                                                                    var videoId: String
                                                                    var playlistId: String
                                                                }
                                                            }
                                                        }
                                                    }
                                                    var videoCountText: VideoCountTextResponse
                                                    struct VideoCountTextResponse: Decodable {
                                                        var runs: [RunResponse]
                                                        struct RunResponse: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                    var videoCountShortText: VideoCountShortTextResponse
                                                    struct VideoCountShortTextResponse: Decodable {
                                                        var simpleText: String
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // SHORTS
                        var richGridRenderer: RichGridRendererResponse?
                        struct RichGridRendererResponse: Decodable {
                            var contents: [ContentResponse]
                            struct ContentResponse: Decodable {
                                var richItemRenderer: RichItemRendererResponse?
                                struct RichItemRendererResponse: Decodable {
                                    var content: ContentResponse
                                    struct ContentResponse: Decodable {
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
                                            var publishedTimeText: SimpleTextResponse?
                                            struct SimpleTextResponse: Decodable {
                                                var simpleText: String
                                            }
                                            var lengthText: SimpleTextResponse
                                            var viewCountText: SimpleTextResponse?
                                            var navigationEndpoint: NavigationEndpointResponse
                                            struct NavigationEndpointResponse: Decodable {
                                                var watchEndpoint: WatchEndpointDecodable
                                                struct WatchEndpointDecodable: Decodable {
                                                    var videoId: String
                                                }
                                            }
                                        }
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
