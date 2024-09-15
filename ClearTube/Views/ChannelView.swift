import SwiftUI
import Observation

@Observable
class ChannelViewModel {
    var channelId: String
    var loading = true
    var error: Error?
    var channel: ChannelObject?
    var videos: [VideoObject] = []
    var selectedTab: ChannelTab = .videos(.videos)

    init(channelId: String) {
        self.channelId = channelId
    }

    enum ChannelTab: Hashable {
        case videos(ChannelVideosViewModel.VideosList)
        case playlists

        var displayName: String {
            switch self {
            case .videos(.videos):
                "Videos"
            case .videos(.shorts):
                "Shorts"
            case .videos(.streams):
                "Streams"
            case .playlists:
                "Playlists"
            }
        }
    }

    func load() async {
        if loading {
            loading = true
            error = nil
            do {
                channel = try await ClearTubeApp.client.channel(for: channelId)
            } catch {
                print(error)
                self.error = error
            }
            loading = false
        }
    }
}

struct ChannelView: View {
    @Bindable var model: ChannelViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            if let channel = model.channel {
                ChannelHeaderView(channel: channel, selection: $model.selectedTab)
                    .padding(.bottom, 50)
                switch model.selectedTab {
                case .videos(let list):
                    ChannelVideosView(model: ChannelVideosViewModel(list: list, channelId: model.channelId))
                        .padding()
                case .playlists:
                    ChannelPlaylistsView(model: ChannelPlaylistsViewModel(channelId: model.channelId))
                        .padding(50)
                }
            }
        }
        .asyncTaskOverlay(error: model.error, isLoading: model.loading)
        .onAppear {
            Task {
                await model.load()
            }
        }
        .refreshable {
            await model.load()
        }
    }
}

struct ChannelHeaderView: View {
    var channel: ChannelObject
    @Binding var selection: ChannelViewModel.ChannelTab
    @FocusState private var isPickerFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                PreferredImage(width: 64, height: 64, images: channel.authorThumbnails)
                VStack(alignment: .leading) {
                    Group {
                        if channel.authorVerified {
                            Text(channel.author) + Text(" ") + Text(Image(systemName: "checkmark.seal.fill")).foregroundStyle(.tint)
                        } else {
                            Text(channel.author)
                        }
                    }.fontWeight(.medium)
                    Text("\(channel.subCount.formatted()) Subscribers").foregroundStyle(.secondary)
                }
                Spacer()
                FollowButton(channel: channel)
            }

            GeometryReader { proxy in
                Picker(selection: $selection) {
                    Text("Videos").tag(ChannelViewModel.ChannelTab.videos(.videos))
                    Text("Shorts").tag(ChannelViewModel.ChannelTab.videos(.shorts))
                    Text("Streams").tag(ChannelViewModel.ChannelTab.videos(.streams))
                    Text("Playlists").tag(ChannelViewModel.ChannelTab.playlists)
                } label: {}
                .labelsHidden()
                .modify {
                    if proxy.size.width >= 768 {
                        $0.pickerStyle(.segmented)
                    } else {
                        $0.pickerStyle(.menu)
                    }
                }
                .focused($isPickerFocused) // Bind focus state to the picker
                .onAppear {
                    isPickerFocused = true // Set focus to the picker when the view appears
                }
            }
        }.padding()
    }
}

@Observable
class ChannelVideosViewModel {
    var channelId: String
    var list: VideosList
    var videos: [VideoObject]?
    var continuation: String?
    var done = false
    var loading = true
    var error: Error?

    enum VideosList {
        case videos
        case shorts
        case streams
    }

    init(list: VideosList, channelId: String) {
        self.list = list
        self.channelId = channelId
    }

    func load() async {
        loading = false
        error = nil
        do {
            let response = switch list {
            case .videos:
                try await ClearTubeApp.client.videos(for: channelId, continuation: continuation)
            case .shorts:
                try await ClearTubeApp.client.shorts(for: channelId, continuation: continuation)
            case .streams:
                try await ClearTubeApp.client.streams(for: channelId, continuation: continuation)
            }
            continuation = response.continuation

            guard var videos = videos else {
                self.videos = response.videos
                return
            }
            if let video = videos.first, response.videos.firstIndex(of: video) != nil {
                done = true
            } else if response.videos.isEmpty {
                done = true
            } else {
                videos.append(contentsOf: response.videos)
            }
        } catch {
            print(error)
            self.error = error
        }
        loading = false
    }
}

struct ChannelVideosView: View {
    var model: ChannelVideosViewModel

    var body: some View {
        if let videos = model.videos {
            if videos.isEmpty {
                Text("No Videos")
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
                    ForEach(videos, id: \.videoId) { video in
                        VideoCard(video: video)
                    }
                }
            }
        }
        if !model.done {
            ProgressView()
                .task(id: model.list) {
                    await model.load()
                }.refreshable {
                    await model.load()
                }
        }
    }
}


@Observable
class ChannelPlaylistsViewModel {
    var channelId: String
    var playlists: [PlaylistObject] = []
    var continuation: String?
    var done = false
    var loading = true
    var error: Error?

    init(channelId: String) {
        self.channelId = channelId
    }

    func load() async {
        loading = false
        do {
            let response = try await ClearTubeApp.client.playlists(for: channelId, continuation: continuation)
            continuation = response.continuation
            if let video = playlists.first, response.playlists.firstIndex(of: video) != nil {
                done = true
            } else {
                playlists.append(contentsOf: response.playlists)
            }
        } catch {
            self.error = error
        }
        loading = false
    }
}

struct ChannelPlaylistsView: View {
    var model: ChannelPlaylistsViewModel

    var body: some View {
        LazyVStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
                ForEach(model.playlists, id: \.playlistId) { playlist in
                    PlaylistItemView(
                        id: playlist.playlistId,
                        title: playlist.title,
                        thumbnail: playlist.playlistThumbnail,
                        author: playlist.author,
                        videoCount: playlist.videoCount
                    ).padding()
                }
            }
            if !model.done {
                ProgressView()
                    .task(id: model.channelId) {
                        await model.load()
                    }.refreshable {
                        await model.load()
                    }
            }
        }.padding().asyncTaskOverlay(error: model.error, isLoading: model.loading)
    }
}
