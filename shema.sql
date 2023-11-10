CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30)
);



CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    multiplayer VARCHAR(30) NOT NULL,
    last_played_at DATE NOT NULL,
    label_id INT,
    genre_id INT,
    author_id INT,
    published_date DATE,
    archived BOOLEAN,
    FOREIGN KEY (label_id) REFERENCES labels(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
    FOREIGN KEY (author_id) REFERENCES authors(id) 
);
