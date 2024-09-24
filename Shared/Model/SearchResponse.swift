import Foundation

struct SearchResponse: Decodable {
    var estimatedResults: String
    var contents: Contents
    struct Contents: Decodable {
        var sectionListRenderer: SectionListRenderer
        struct SectionListRenderer: Decodable {
            var contents: [Content]
            struct Content: Decodable {
                var shelfRenderer: ShelfRenderer?
                struct ShelfRenderer: Decodable {
                    var content: ContentRenderer
                    struct ContentRenderer: Decodable {
                        var verticalListRenderer: VerticalListRenderer
                        struct VerticalListRenderer: Decodable {
                            var items: [Item]
                            struct Item: Decodable {
                                var elementRenderer: ElementRenderer?
                            }
                        }
                    }
                }
                var itemSectionRenderer: ItemSectionRenderer?
                struct ItemSectionRenderer: Decodable {
                    var contents: [Content]
                    struct Content: Decodable {
                        var elementRenderer: ElementRenderer?
                    }
                }
            }
        }
    }
}

struct ElementRenderer: Decodable {
    var newElement: NewElement
    struct NewElement: Decodable {
        var type: TypeStruct
        struct TypeStruct: Decodable {
            var componentType: ComponentType?
            struct ComponentType: Decodable {
                var model: Model
                struct Model: Decodable {
                    var compactChannelModel: CompactChannelModel?
                    struct CompactChannelModel: Decodable {
                        var compactChannelData: CompactChannelData
                        struct CompactChannelData: Decodable {
                            var avatar: Avatar
                            struct Avatar: Decodable {
                                var image: Image
                                struct Image: Decodable {
                                    var sources: [ImageObject]
                                }
                            }
                            var title: String
                            var subscriberCount: String
                            var videoCount: String
                            var onTap: OnTap
                            struct OnTap: Decodable {
                                var innertubeCommand: InnertubeCommand
                                struct InnertubeCommand: Decodable {
                                    var browseEndpoint: BrowseEndpoint
                                    struct BrowseEndpoint: Decodable {
                                        var browseId: String
                                        var canonicalBaseUrl: String
                                    }
                                }
                            }
                            var handle: String
                        }
                    }
                    var compactVideoModel: CompactVideoModel?
                    struct CompactVideoModel: Decodable {
                        var compactVideoData: CompactVideoData
                        struct CompactVideoData: Decodable {
                            var videoData: VideoData
                            struct VideoData: Decodable {
                                var thumbnail: Thumbnail
                                struct Thumbnail: Decodable {
                                    var image: Image
                                    struct Image: Decodable {
                                        var sources: [ImageObject]
                                    }
                                    var timestampText: String?
                                }
                                var metadata: Metadata
                                struct Metadata: Decodable {
                                    var title: String
                                    var byline: String
                                    var metadataDetails: String
                                }
                            }
                            var onTap: OnTap
                            struct OnTap: Decodable {
                                var innertubeCommand: InnertubeCommand
                                struct InnertubeCommand: Decodable {
                                    var coWatchWatchEndpointWrapperCommand: CoWatchWatchEndpointWrapperCommand
                                    struct CoWatchWatchEndpointWrapperCommand: Decodable {
                                        var watchEndpoint: WatchEndpoint
                                        struct WatchEndpoint: Decodable {
                                            var watchEndpoint: WatchEndpoint
                                            struct WatchEndpoint: Decodable {
                                                var videoId: String
                                            }
                                        }
                                        var videoTitle: String
                                        var ownerDisplayName: String
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
