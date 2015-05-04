SELECT *
FROM (
	SELECT 
		b.artist_id AS artist_id,
		artist,
		b.id AS album_id,
		album
	FROM artists a
	INNER JOIN albums b 
	ON a.id = b.artist_id
) t1 
INNER JOIN album_lyrics_map t2 
ON t1.album_id = t2.album_id
WHERE lyrics IS NOT NULL