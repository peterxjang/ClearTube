import Foundation

struct SearchResponse: Decodable {
    var estimatedResults: String
    var contents: ContentsResponse
    struct ContentsResponse: Decodable {
        var sectionListRenderer: SectionListRendererResponse
        struct SectionListRendererResponse: Decodable {
            var contents: [ContentResponse]
            struct ContentResponse: Decodable {
                // CHANNEL
                var shelfRenderer: ShelfRendererResponse?
                struct ShelfRendererResponse: Decodable {
                    var content: ContentResponse
                    struct ContentResponse: Decodable {
                        var verticalListRenderer: VerticalListRendererResponse
                        struct VerticalListRendererResponse: Decodable {
                            var items: [ItemResponse]
                            struct ItemResponse: Decodable {
                                var elementRenderer: ElementRendererResponse
                                struct ElementRendererResponse: Decodable {
                                    var newElement: NewElementResponse
                                    struct NewElementResponse: Decodable {
                                        var type: TypeResponse
                                        struct TypeResponse: Decodable {
                                            var componentType: ComponentTypeResponse
                                            struct ComponentTypeResponse: Decodable {
                                                var model: ModelResponse
                                                struct ModelResponse: Decodable {
                                                    var compactChannelModel: CompactChannelModelResponse?
                                                    struct CompactChannelModelResponse: Decodable {
                                                        var compactChannelData: CompactChannelDataResponse
                                                        struct CompactChannelDataResponse: Decodable {
                                                            var avatar: AvatarResponse
                                                            struct AvatarResponse: Decodable {
                                                                var image: ImageResponse
                                                                struct ImageResponse: Decodable {
                                                                    var sources: [ImageObject]
                                                                }
                                                            }
                                                            var title: String
                                                            var subscriberCount: String
                                                            var videoCount: String
                                                            var onTap: OnTapResponse
                                                            struct OnTapResponse: Decodable {
                                                                var innertubeCommand: InnertubeCommandResponse
                                                                struct InnertubeCommandResponse: Decodable {
                                                                    var browseEndpoint: BrowseEndpointResponse
                                                                    struct BrowseEndpointResponse: Decodable {
                                                                        var browseId: String
                                                                        var canonicalBaseUrl: String
                                                                    }
                                                                }
                                                            }
                                                            var handle: String
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
                // VIDEO
                var itemSectionRenderer: ItemSectionRendererResponse?
                struct ItemSectionRendererResponse: Decodable {
                    var contents: [ContentResponse]
                    struct ContentResponse: Decodable {
                        var elementRenderer: ElementRendererResponse?
                        struct ElementRendererResponse: Decodable {
                            var newElement: NewElementResponse
                            struct NewElementResponse: Decodable {
                                var type: TypeResponse
                                struct TypeResponse: Decodable {
                                    var componentType: ComponentTypeResponse?
                                    struct ComponentTypeResponse: Decodable {
                                        var model: ModelResponse
                                        struct ModelResponse: Decodable {
                                            var compactVideoModel: CompactVideoModelResponse?
                                            struct CompactVideoModelResponse: Decodable {
                                                var compactVideoData: CompactVideoDataResponse
                                                struct CompactVideoDataResponse: Decodable {
                                                    var videoData: VideoDataResponse
                                                    struct VideoDataResponse: Decodable {
                                                        var thumbnail: ThumbnailResponse
                                                        struct ThumbnailResponse: Decodable {
                                                            var image: ImageResponse
                                                            struct ImageResponse: Decodable {
                                                                var sources: [ImageObject]
                                                            }
                                                            var timestampText: String?
                                                        }
                                                        var metadata: MetadataResponse
                                                        struct MetadataResponse: Decodable {
                                                            var title: String
                                                            var byline: String
                                                            var metadataDetails: String
                                                        }
                                                    }
                                                    var onTap: OnTapResponse
                                                    struct OnTapResponse: Decodable {
                                                        var innertubeCommand: InnertubeCommandResponse
                                                        struct InnertubeCommandResponse: Decodable {
                                                            var coWatchWatchEndpointWrapperCommand: CoWatchWatchEndpointWrapperCommandResponse
                                                            struct CoWatchWatchEndpointWrapperCommandResponse: Decodable {
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
                    }
                }
            }
        }
    }
}
