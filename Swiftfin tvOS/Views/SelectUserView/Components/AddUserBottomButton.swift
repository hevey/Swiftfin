//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import OrderedCollections
import SwiftUI

extension SelectUserView {

    struct AddUserBottomButton: View {

        // MARK: Properties

        private let action: (ServerState) -> Void
        private let servers: OrderedSet<ServerState>
        private let serverSelection: SelectUserServerSelection

        private var selectedServer: ServerState? {
            if case let SelectUserServerSelection.server(id: id) = serverSelection,
               let server = servers.first(where: { server in server.id == id })
            {
                return server
            }

            return nil
        }

        // MARK: View Builders

        @ViewBuilder
        private var buttonLabel: some View {
            Label(L10n.addUser, systemImage: "person.crop.circle.badge.plus")
                .foregroundStyle(Color.primary)
                .font(.body.weight(.semibold))
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
        }

        // MARK: - Initializer

        init(
            serverSelection: SelectUserServerSelection,
            servers: OrderedSet<ServerState>,
            action: @escaping (ServerState) -> Void
        ) {
            self.action = action
            self.servers = servers
            self.serverSelection = serverSelection
        }

        // MARK: Body

        var body: some View {
            if serverSelection == .all {
                Menu {
                    Text(L10n.selectServer)

                    ForEach(servers) { server in
                        Button {
                            action(server)
                        } label: {
                            Text(server.name)
                            Text(server.currentURL.absoluteString)
                        }
                    }
                } label: {
                    buttonLabel
                }

            } else {
                Button {
                    if let selectedServer {
                        action(selectedServer)
                    }
                } label: {
                    buttonLabel
                }
            }
        }
    }
}
