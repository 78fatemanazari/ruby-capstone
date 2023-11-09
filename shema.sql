-- schema.sql

-- Table for items (parent class for books and music albums)
CREATE TABLE items (
    id INT PRIMARY KEY,
    publish_date DATETIME
);

-- Table for books
CREATE TABLE books (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    cover_state VARCHAR(50),
    publisher VARCHAR(255),
    item_id INT,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

-- Table for music albums
CREATE TABLE music_albums (
    id INT PRIMARY KEY,
    on_spotify BOOLEAN,
    item_id INT,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

-- Table for genres
CREATE TABLE genres (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Table for items_genres association (many-to-many relationship)
CREATE TABLE items_genres (
    item_id INT,
    genre_id INT,
    FOREIGN KEY (item_id) REFERENCES items(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
    PRIMARY KEY (item_id, genre_id)
);
