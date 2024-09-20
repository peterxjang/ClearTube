import SwiftUI

enum ChannelCategory {
    case videos
    case shorts
    case streams
    case playlists
}

struct ChannelView: View {
    var channelId: String
    @FocusState private var isPickerFocused: Bool
    @State var selection: ChannelCategory = ChannelCategory.videos
    @State var channel: ChannelObject?
    @State var channelVideos: [VideoObject]?
    @State var channelShorts: [VideoObject]?
    @State var channelStreams: [VideoObject]?
    @State var channelPlaylists: [PlaylistObject]?

    var body: some View {
        ScrollView {
            if let channel = channel {
                ChannelHeaderView(channel: channel, selection: $selection)
                    .padding(.bottom, 100)
                switch selection {
                case ChannelCategory.videos:
                    ChannelVideosView(videos: channelVideos)
                        .onAppear {
                            if channelVideos == nil {
                                Task {
                                    await fetchChannelVideos()
                                }
                            }
                        }
                case ChannelCategory.shorts:
                    ChannelVideosView(videos: channelShorts)
                        .onAppear {
                            if channelShorts == nil {
                                Task {
                                    await fetchChannelShorts()
                                }
                            }
                        }
                case ChannelCategory.streams:
                    ChannelVideosView(videos: channelStreams)
                        .onAppear {
                            if channelStreams == nil {
                                Task {
                                    await fetchChannelStreams()
                                }
                            }
                        }
                case ChannelCategory.playlists:
                    ChannelPlaylistsView(playlists: channelPlaylists)
                        .onAppear {
                            if channelPlaylists == nil {
                                Task {
                                    await fetchChannelPlaylists()
                                }
                            }
                        }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if channel == nil {
                Task {
                    await fetchChannel()
                }
            }
        }
    }

    private func fetchChannel() async {
        do {
            channel = try await ClearTubeApp.innerTubeClient.channel(for: channelId)
        } catch {
            print("Error fetching channel: \(error)")
        }
    }

    private func fetchChannelVideos() async {
        do {
            let result = try await ClearTubeApp.innerTubeClient.videos(for: channelId, continuation: nil)
            channelVideos = result.videos
        } catch {
            print("Error fetching channel videos: \(error)")
        }
    }

    private func fetchChannelShorts() async {
        do {
            let result = try await ClearTubeApp.innerTubeClient.shorts(for: channelId, continuation: nil)
            channelShorts = result.videos
        } catch {
            print("Error fetching channel shorts: \(error)")
        }
    }

    private func fetchChannelStreams() async {
        do {
            let result = try await ClearTubeApp.innerTubeClient.streams(for: channelId, continuation: nil)
            channelStreams = result.videos
        } catch {
            print("Error fetching channel streams: \(error)")
        }
    }

    private func fetchChannelPlaylists() async {
        do {
            let result = try await ClearTubeApp.innerTubeClient.playlists(for: channelId, continuation: nil)
            channelPlaylists = result.playlists
        } catch {
            print("Error fetching channel playlists: \(error)")
        }
    }
}

struct ChannelHeaderView: View {
    var channel: ChannelObject
    @Binding var selection: ChannelCategory

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                PreferredImage(width: 64, height: 64, images: channel.authorThumbnails)
                VStack(alignment: .leading) {
                    Group {
                        Text(channel.author)
                    }.fontWeight(.medium)
                    Text(channel.subCountTextDisplay()).foregroundStyle(.secondary)
                }
                Spacer()
                FollowButton(channel: channel)
            }

            GeometryReader { proxy in
                Picker(selection: $selection) {
                    Text("Videos").tag(ChannelCategory.videos)
                    Text("Shorts").tag(ChannelCategory.shorts)
                    Text("Streams").tag(ChannelCategory.streams)
                    Text("Playlists").tag(ChannelCategory.playlists)
                } label: {}
                .labelsHidden()
                .modify {
                    if proxy.size.width >= 768 {
                        $0.pickerStyle(.segmented)
                    } else {
                        $0.pickerStyle(.menu)
                    }
                }
            }
        }
    }
}

struct ChannelVideosView: View {
    var videos: [VideoObject]?

    var body: some View {
        if let videos = videos {
            if videos.isEmpty {
                Text("No Videos")
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
                    ForEach(videos, id: \.videoId) { video in
                        VideoCard(video: video)
                    }
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct ChannelPlaylistsView: View {
    var playlists: [PlaylistObject]?

    var body: some View {
        if let playlists = playlists {
            if playlists.isEmpty {
                Text("No Playlists")
            } else {
                LazyVStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
                        ForEach(playlists, id: \.playlistId) { playlist in
                            PlaylistItemView(
                                id: playlist.playlistId,
                                title: playlist.title,
                                thumbnail: playlist.playlistThumbnail,
                                author: playlist.author,
                                videoCount: playlist.videoCount
                            ).padding()
                        }
                    }
                }.padding()
            }
        } else {
            ProgressView()
        }
    }
}
