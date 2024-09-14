import SwiftUI

struct VideoThumbnailTag: View {
    var lengthSeconds: Int

    private var formattedDuration: String {
        (Date() ..< Date().advanced(by: TimeInterval(lengthSeconds))).formatted(.timeDuration)
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Group {
                    Text(formattedDuration)
                        .padding(.horizontal, 6.0)
                        .padding(.vertical, 2.0)
                        .font(.caption2)
                }
                .background(.black)
                .foregroundStyle(.white)
                .cornerRadius(4.0)
                .padding([.bottom, .trailing], 4.0)
            }
        }
    }
}
