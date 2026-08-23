-- SPDX-FileCopyrightText: 2026 Slavi Pantaleev
--
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- The schema of a Calibre library database (`metadata.db`), used by the
-- Molecule scenarios to hand Calibre-Web an empty but valid library.
--
-- Calibre-Web refuses to leave its first-run "Database Configuration" wizard
-- until it is pointed at a directory holding a readable `metadata.db`, and it
-- will not create one itself, so a test that wants to reach the actual
-- application has to bring its own.
--
-- The statements below are the ones Calibre-Web's own SQLAlchemy models emit
-- (`cps.db.Base.metadata`), with the `calibre.` schema prefix removed, so this
-- is exactly the shape the application expects to find rather than an
-- approximation of it. A library also needs a row in `library_id`; the seeding
-- task adds one, because the UUID has to be generated per test run.

CREATE TABLE authors (
    id INTEGER NOT NULL,
    name VARCHAR COLLATE "NOCASE" NOT NULL,
    sort VARCHAR COLLATE "NOCASE",
    link VARCHAR NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);
CREATE TABLE books (
    id INTEGER NOT NULL,
    title VARCHAR COLLATE "NOCASE" NOT NULL,
    sort VARCHAR COLLATE "NOCASE",
    author_sort VARCHAR COLLATE "NOCASE",
    timestamp TIMESTAMP,
    pubdate TIMESTAMP,
    series_index VARCHAR NOT NULL,
    last_modified TIMESTAMP,
    path VARCHAR NOT NULL,
    has_cover INTEGER,
    uuid VARCHAR,
    PRIMARY KEY (id)
);
CREATE TABLE custom_columns (
    id INTEGER NOT NULL,
    label VARCHAR,
    name VARCHAR,
    datatype VARCHAR,
    mark_for_delete BOOLEAN,
    editable BOOLEAN,
    display VARCHAR,
    is_multiple BOOLEAN,
    normalized BOOLEAN,
    PRIMARY KEY (id)
);
CREATE TABLE languages (
    id INTEGER NOT NULL,
    lang_code VARCHAR COLLATE "NOCASE" NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (lang_code)
);
CREATE TABLE library_id (
    id INTEGER NOT NULL,
    uuid VARCHAR NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE publishers (
    id INTEGER NOT NULL,
    name VARCHAR COLLATE "NOCASE" NOT NULL,
    sort VARCHAR COLLATE "NOCASE",
    PRIMARY KEY (id),
    UNIQUE (name)
);
CREATE TABLE ratings (
    id INTEGER NOT NULL,
    rating INTEGER CHECK (rating>-1 AND rating<11),
    PRIMARY KEY (id),
    UNIQUE (rating)
);
CREATE TABLE series (
    id INTEGER NOT NULL,
    name VARCHAR COLLATE "NOCASE" NOT NULL,
    sort VARCHAR COLLATE "NOCASE",
    PRIMARY KEY (id),
    UNIQUE (name)
);
CREATE TABLE tags (
    id INTEGER NOT NULL,
    name VARCHAR COLLATE "NOCASE" NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);
CREATE TABLE books_authors_link (
    book INTEGER NOT NULL,
    author INTEGER NOT NULL,
    PRIMARY KEY (book, author),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(author) REFERENCES authors (id)
);
CREATE TABLE books_languages_link (
    book INTEGER NOT NULL,
    lang_code INTEGER NOT NULL,
    PRIMARY KEY (book, lang_code),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(lang_code) REFERENCES languages (id)
);
CREATE TABLE books_publishers_link (
    book INTEGER NOT NULL,
    publisher INTEGER NOT NULL,
    PRIMARY KEY (book, publisher),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(publisher) REFERENCES publishers (id)
);
CREATE TABLE books_ratings_link (
    book INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    PRIMARY KEY (book, rating),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(rating) REFERENCES ratings (id)
);
CREATE TABLE books_series_link (
    book INTEGER NOT NULL,
    series INTEGER NOT NULL,
    PRIMARY KEY (book, series),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(series) REFERENCES series (id)
);
CREATE TABLE books_tags_link (
    book INTEGER NOT NULL,
    tag INTEGER NOT NULL,
    PRIMARY KEY (book, tag),
    FOREIGN KEY(book) REFERENCES books (id),
    FOREIGN KEY(tag) REFERENCES tags (id)
);
CREATE TABLE data (
    id INTEGER NOT NULL,
    book INTEGER NOT NULL,
    format VARCHAR COLLATE "NOCASE" NOT NULL,
    uncompressed_size INTEGER NOT NULL,
    name VARCHAR NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE comments (
    id INTEGER NOT NULL,
    book INTEGER NOT NULL,
    text VARCHAR COLLATE "NOCASE" NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (book),
    FOREIGN KEY(book) REFERENCES books (id)
);
CREATE TABLE identifiers (
    id INTEGER NOT NULL,
    type VARCHAR COLLATE "NOCASE" NOT NULL,
    val VARCHAR COLLATE "NOCASE" NOT NULL,
    book INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY(book) REFERENCES books (id)
);
CREATE TABLE metadata_dirtied (
    id INTEGER NOT NULL,
    book INTEGER NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (book),
    FOREIGN KEY(book) REFERENCES books (id)
);
