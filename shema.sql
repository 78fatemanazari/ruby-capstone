CREATE TABLE games (
    id INT PRIMARY KEY,
    multiplayer BOOLEAN,
    last_played_at DATETIME,
    -- Foreign key referencing the items table
    item_id INT REFERENCES items(id)
);

-- Table for authors
CREATE TABLE authors (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
);

-- Table for the association between authors and items (many-to-many relationship)
CREATE TABLE author_items (
    author_id INT REFERENCES authors(id),
    item_id INT REFERENCES items(id)
);

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
)

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  publisher VARCHAR(255),
  cover_state VARCHAR(255)
);

CREATE TABLE labels (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  color VARCHAR(255)
);
