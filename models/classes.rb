class Artist < Sequel::Model
	set_dataset :artists
	def self.artistId(artistName)
		artistId = DB[
			"SELECT id
			FROM artists 
			WHERE LOWER( REPLACE(artist,'\"','') ) = LOWER(?)
			LIMIT 1",
			artistName
		].map{|resultRow|
			resultRow[:id]
		}[0]

		return artistId
	end
end

class Track < Sequel::Model
	set_dataset :album_lyrics_map
	def self.songIds(artistId,songName)
		result = DB[
			"SELECT row
			FROM album_lyrics_map a
			INNER JOIN albums b ON a.album_id=b.id
			INNER JOIN artists c ON b.artist_id=c.id
			WHERE 
				LOWER( REPLACE(artist_id,'\"','') ) = LOWER( REPLACE(?,'\"','') )
				AND LOWER( REPLACE(track,'\"','') ) = LOWER( REPLACE(?,'\"','') )
				AND lyrics IS NULL",
				artistId,songName
		].map{|resultRow|
			resultRow[:row]
		}
		
		# result = DB[
		# 	"SELECT row
		# 	FROM artist_lyrics_map
		# 	INNER JOIN 
		# 	WHERE 
		# 		LOWER( REPLACE(artist_name,'\"','') ) = LOWER( REPLACE(?,'\"','') )
		# 		AND LOWER( REPLACE(track_name,'\"','') ) = LOWER( REPLACE(?,'\"','') )
		# 		AND lyrics IS NULL",
		# 	artistName,songName
		# ].map{|resultRow| 
		# 	resultRow[:id]
		# }
		return result
	end
end