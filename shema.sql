-- Table for games
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