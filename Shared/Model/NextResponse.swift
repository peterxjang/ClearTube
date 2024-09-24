import Foundation

struct NextResponse: Decodable {
    var contents: Contents
    struct Contents: Decodable {
        var singleColumnWatchNextResults: SingleColumnWatchNextResults
        struct SingleColumnWatchNextResults: Decodable {
            var results: Results
            struct Results: Decodable {
                var results: Results
                struct Results: Decodable {
                    var contents: [Content]
                    struct Content: Decodable {
                        var shelfRenderer: ShelfRenderer?
                        struct ShelfRenderer: Decodable {
                            var content: Content
                            struct Content: Decodable {
                                var horizontalListRenderer: HorizontalListRenderer
                                struct HorizontalListRenderer: Decodable {
                                    var items: [Item]
                                    struct Item: Decodable {
                                        var gridVideoRenderer: GridVideoRenderer?
                                        struct GridVideoRenderer: Decodable {
                                            var videoId: String
                                            var thumbnail: Thumbnail
                                            struct Thumbnail: Decodable {
                                                var thumbnails: [ImageObject]
                                            }
                                            var title: TitleObject
                                            struct TitleObject: Decodable {
                                                var runs: [Run]
                                                struct Run: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var publishedTimeText: PublishedTimeTextObject
                                            struct PublishedTimeTextObject: Decodable {
                                                var runs: [Run]
                                                struct Run: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var viewCountText: ViewCountTextObject
                                            struct ViewCountTextObject: Decodable {
                                                var runs: [Run]
                                                struct Run: Decodable {
                                                    var text: String
                                                }
                                            }
                                            var lengthText: LengthTextObject
                                            struct LengthTextObject: Decodable {
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
                                                        var browseEndpoint: BrowseEndpoint?
                                                        struct BrowseEndpoint: Decodable {
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
    var engagementPanels: [EngagementPanel]?
    struct EngagementPanel: Decodable {
        var engagementPanelSectionListRenderer: EngagementPanelSectionListRenderer
        struct EngagementPanelSectionListRenderer: Decodable {
            var content: Content
            struct Content: Decodable {
                var transcriptRenderer: TranscriptRenderer?
                struct TranscriptRenderer: Decodable {
                    var content: Content
                    struct Content: Decodable {
                        var elementRenderer: ElementRenderer
                        struct ElementRenderer: Decodable {
                            var newElement: NewElement
                            struct NewElement: Decodable {
                                var type: TypeResponse
                                struct TypeResponse: Decodable {
                                    var componentType: ComponentType
                                    struct ComponentType: Decodable {
                                        var model: Model
                                        struct Model: Decodable {
                                            var transcriptPanelModel: TranscriptPanelModel
                                            struct TranscriptPanelModel: Decodable {
                                                var serializedTranscriptRequestParams: String
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
