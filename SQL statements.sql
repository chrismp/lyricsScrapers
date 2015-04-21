ALTER TABLE tracks 
ADD INDEX artist_index(artist_name);

ALTER TABLE tracks
ADD INDEX track_index(track_name);

ALTER TABLE tracks
ADD PRIMARY KEY (Id);


DROP TABLE IF EXISTS artists;
CREATE TABLE IF NOT EXISTS artists(
	id INT NOT NULL AUTO_INCREMENT,
	artist VARCHAR(255),
	PRIMARY KEY(id),
	KEY artist_index(artist)
);
INSERT INTO artists(
	artist
)
SELECT DISTINCT TRIM(artist_name)
FROM tracks;


DROP TABLE IF EXISTS albums;
CREATE TABLE IF NOT EXISTS albums(
	id INT NOT NULL AUTO_INCREMENT,
	artist_id INT NOT NULL,
	album VARCHAR(255),
	PRIMARY KEY(id),
	FOREIGN KEY(artist_id) REFERENCES artists(id),
	KEY artist_index(artist_id),
	KEY album_index(album),
	UNIQUE KEY artist_album(artist_id,album)
);
INSERT INTO albums(
	artist_id,
	album
)
SELECT DISTINCT
	b.id,
	album_name
FROM tracks a 
INNER JOIN artists b 
	ON a.artist_name = b.artist;


DROP TABLE IF EXISTS album_lyrics_map;
CREATE TABLE IF NOT EXISTS album_lyrics_map(
	row INT NOT NULL AUTO_INCREMENT,
	album_id INT NOT NULL,
	track VARCHAR(255),
	lyrics MEDIUMTEXT,
	PRIMARY KEY(row),
	FOREIGN KEY(album_id) REFERENCES albums(id),
	KEY album_index(album_id)
);
INSERT INTO album_lyrics_map(
	album_id,
	track
)
SELECT 
	album_id,
	track_name
FROM (
	SELECT
		a.id AS album_id,
		album,
		artist_id, 
		artist
	FROM albums a 
	INNER JOIN artists b ON a.artist_id = b.id
) ab 
INNER JOIN tracks c 
	ON ab.artist=c.artist_name  
	AND ab.album=c.album_name;
