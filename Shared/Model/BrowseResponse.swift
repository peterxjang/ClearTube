import Foundation

struct BrowseResponse: Decodable {
    var header: Header
    struct Header: Decodable {
        var playlistHeaderRenderer: PlaylistHeaderRenderer?
        struct PlaylistHeaderRenderer: Decodable {
            var playlistId: String
            var title: Title
            struct Title: Decodable {
                var simpleText: String
            }
            var numVideosText: NumVideosText
            struct NumVideosText: Decodable {
                var runs: [Run]
                struct Run: Decodable {
                    var text: String
                }
            }
            var ownerText: OwnerText
            struct OwnerText: Decodable {
                var runs: [Run]
                struct Run: Decodable {
                    var text: String
                    var navigationEndpoint: NavigationEndpoint
                    struct NavigationEndpoint: Decodable {
                        var browseEndpoint: BrowseEndpoint
                        struct BrowseEndpoint: Decodable {
                            var browseId: String
                            var canonicalBaseUrl: String
                        }
                    }
                }
            }
        }
        var pageHeaderRenderer: PageHeaderRenderer?
        struct PageHeaderRenderer: Decodable {
            var pageTitle: String
            var content: Content
            struct Content: Decodable {
                var pageHeaderViewModel: PageHeaderViewModel
                struct PageHeaderViewModel: Decodable {
                    var image: Image?
                    struct Image: Decodable {
                        var decoratedAvatarViewModel: DecoratedAvatarViewModel
                        struct DecoratedAvatarViewModel: Decodable {
                            var avatar: Avatar
                            struct Avatar: Decodable {
                                var avatarViewModel: AvatarViewModel
                                struct AvatarViewModel: Decodable {
                                    var image: Image
                                    struct Image: Decodable {
                                        var sources: [ImageObject]
                                    }
                                }
                            }
                        }
                    }
                    var metadata: Metadata
                    struct Metadata: Decodable {
                        var contentMetadataViewModel: ContentMetadataViewModel
                        struct ContentMetadataViewModel: Decodable {
                            var metadataRows: [MetadataRow]
                            struct MetadataRow: Decodable {
                                var metadataParts: [MetadataPart]
                                struct MetadataPart: Decodable {
                                    var text: Text?
                                    struct Text: Decodable {
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
    var contents: Contents
    struct Contents: Decodable {
        var twoColumnBrowseResultsRenderer: TwoColumnBrowseResultsRenderer
        struct TwoColumnBrowseResultsRenderer: Decodable {
            var tabs: [Tab]
            struct Tab: Decodable {
                var tabRenderer: TabRenderer?
                struct TabRenderer: Decodable {
                    var endpoint: Endpoint?
                    struct Endpoint: Decodable {
                        var browseEndpoint: BrowseEndpoint
                        struct BrowseEndpoint: Decodable {
                            var browseId: String
                            var params: String
                            var canonicalBaseUrl: String
                        }
                    }
                    var title: String?
                    var content: Content?
                    struct Content: Decodable {
                        var sectionListRenderer: SectionListRenderer?
                        struct SectionListRenderer: Decodable {
                            var contents: [Content]
                            struct Content: Decodable {
                                var itemSectionRenderer: ItemSectionRenderer?
                                struct ItemSectionRenderer: Decodable {
                                    var contents: [Content]
                                    struct Content: Decodable {
                                        // PLAYLIST
                                        var playlistVideoListRenderer: PlaylistVideoListRenderer?
                                        struct PlaylistVideoListRenderer: Decodable {
                                            var contents: [Content]
                                            struct Content: Decodable {
                                                var playlistVideoRenderer: PlaylistVideoRenderer?
                                                struct PlaylistVideoRenderer: Decodable {
                                                    var videoId: String
                                                    var thumbnail: Thumbnail
                                                    struct Thumbnail: Decodable {
                                                        var thumbnails: [ImageObject]
                                                    }
                                                    var title: Title
                                                    struct Title: Decodable {
                                                        var runs: [Run]
                                                        struct Run: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                    var shortBylineText: ShortBylineText
                                                    struct ShortBylineText: Decodable {
                                                        var runs: [Run]
                                                        struct Run: Decodable {
                                                            var text: String
                                                            var navigationEndpoint: NavigationEndpoint
                                                            struct NavigationEndpoint: Decodable {
                                                                var browseEndpoint: BrowseEndpoint
                                                                struct BrowseEndpoint: Decodable {
                                                                    var browseId: String
                                                                    var canonicalBaseUrl: String
                                                                }
                                                            }
                                                        }
                                                    }
                                                    var lengthSeconds: String
                                                    var videoInfo: VideoInfo
                                                    struct VideoInfo: Decodable {
                                                        var runs: [Run]?
                                                        struct Run: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        // VIDEO
                                        var gridRenderer: GridRenderer?
                                        struct GridRenderer: Decodable {
                                            var items: [Item]
                                            struct Item: Decodable {
                                                var gridPlaylistRenderer: GridPlaylistRenderer?
                                                struct GridPlaylistRenderer: Decodable {
                                                    var playlistId: String
                                                    var thumbnail: Thumbnail
                                                    struct Thumbnail: Decodable {
                                                        var thumbnails: [ImageObject]
                                                    }
                                                    var title: Title
                                                    struct Title: Decodable {
                                                        var runs: [Run]
                                                        struct Run: Decodable {
                                                            var text: String
                                                            var navigationEndpoint: NavigationEndpoint
                                                            struct NavigationEndpoint: Decodable {
                                                                var watchEndpoint: WatchEndpoint
                                                                struct WatchEndpoint: Decodable {
                                                                    var videoId: String
                                                                    var playlistId: String
                                                                }
                                                            }
                                                        }
                                                    }
                                                    var videoCountText: VideoCountText
                                                    struct VideoCountText: Decodable {
                                                        var runs: [Run]
                                                        struct Run: Decodable {
                                                            var text: String
                                                        }
                                                    }
                                                    var videoCountShortText: VideoCountShortText
                                                    struct VideoCountShortText: Decodable {
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
                        var richGridRenderer: RichGridRenderer?
                        struct RichGridRenderer: Decodable {
                            var contents: [Content]
                            struct Content: Decodable {
                                var richItemRenderer: RichItemRenderer?
                                struct RichItemRenderer: Decodable {
                                    var content: Content
                                    struct Content: Decodable {
                                        var videoRenderer: VideoRenderer?
                                        struct VideoRenderer: Decodable {
                                            var videoId: String
                                            var thumbnail: Thumbnail
                                            struct Thumbnail: Decodable {
                                                var thumbnails: [ImageObject]
                                            }
                                            var title: Runs
                                            struct Runs: Decodable {
                                                var runs: [Run]
                                                struct Run: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var descriptionSnippet: Runs?
                                            var publishedTimeText: SimpleText?
                                            struct SimpleText: Decodable {
                                                var simpleText: String
                                            }
                                            var lengthText: SimpleText
                                            var viewCountText: SimpleText?
                                            var navigationEndpoint: NavigationEndpoint
                                            struct NavigationEndpoint: Decodable {
                                                var watchEndpoint: WatchEndpointDecodable
                                                struct WatchEndpointDecodable: Decodable {
                                                    var videoId: String
                                                }
                                            }
                                        }
                                        var shortsLockupViewModel: ShortsLockupViewModel?
                                        struct ShortsLockupViewModel: Decodable {
                                            var entityId: String
                                            var thumbnail: Thumbnail
                                            struct Thumbnail: Decodable {
                                                var sources: [ImageObject]
                                            }
                                            var onTap: OnTap
                                            struct OnTap: Decodable {
                                                var innertubeCommand: InnertubeCommand
                                                struct InnertubeCommand: Decodable {
                                                    var reelWatchEndpoint: ReelWatchEndpoint
                                                    struct ReelWatchEndpoint: Decodable {
                                                        var videoId: String
                                                    }
                                                }
                                            }
                                            var overlayMetadata: OverlayMetadata
                                            struct OverlayMetadata: Decodable {
                                                var primaryText: PrimaryText
                                                struct PrimaryText: Decodable {
                                                    var content: String
                                                }
                                                var secondaryText: SecondaryText
                                                struct SecondaryText: Decodable {
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
