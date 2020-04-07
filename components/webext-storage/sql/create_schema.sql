-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

-- This is a very simple schema.
CREATE TABLE IF NOT EXISTS moz_extension_data (
    ext_id TEXT PRIMARY KEY,
    /* The JSON payload. NULL means it's a tombstone */
    data TEXT,

    /* Same "sync change counter" strategy used by other components. */
    syncChangeCounter INTEGER NOT NULL DEFAULT 1
) WITHOUT ROWID;

CREATE TABLE IF NOT EXISTS moz_extension_data_mirror (
    guid TEXT PRIMARY KEY,
    /* The extension_id is explicitly not the GUID used on the server.
       We may end up making this a regular foreign-key relationship back to
       moz_extension_data, although maybe not - the ext_id may not exist in
       moz_extension_data at the time we populate this table.
       We can iterate here as we site up sync support.
    */
    ext_id TEXT NOT NULL UNIQUE,

    /* The JSON payload. We *do* allow NULL here - it means "deleted" */
    data TEXT
) WITHOUT ROWID;

-- This table holds key-value metadata - primarily for sync.
CREATE TABLE IF NOT EXISTS moz_meta (
    key TEXT PRIMARY KEY,
    value NOT NULL
) WITHOUT ROWID;
