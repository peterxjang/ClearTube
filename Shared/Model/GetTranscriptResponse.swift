import Foundation

struct GetTranscriptResponse: Decodable {
    var actions: [Action]
    struct Action: Decodable {
        var updateEngagementPanelAction: UpdateEngagementPanelAction?
        struct UpdateEngagementPanelAction: Decodable {
            var content: Content
            struct Content: Decodable {
                var transcriptRenderer: TranscriptRenderer
                struct TranscriptRenderer: Decodable {
                    var content: Content
                    struct Content: Decodable {
                        var transcriptSearchPanelRenderer: TranscriptSearchPanelRenderer
                        struct TranscriptSearchPanelRenderer: Decodable {
                            var body: Body
                            struct Body: Decodable {
                                var transcriptSegmentListRenderer: TranscriptSegmentListRenderer
                                struct TranscriptSegmentListRenderer: Decodable {
                                    var initialSegments: [InitialSegment]
                                    struct InitialSegment: Decodable {
                                        var transcriptSectionHeaderRenderer: TranscriptSectionHeaderRenderer?
                                        struct TranscriptSectionHeaderRenderer: Decodable {
                                            var startMs: String
                                            var endMs: String
                                            var sectionHeader: SectionHeader
                                            struct SectionHeader: Decodable {
                                                var sectionHeaderViewModel: SectionHeaderViewModel
                                                struct SectionHeaderViewModel: Decodable {
                                                    var headline: Headline
                                                    struct Headline: Decodable {
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
}
