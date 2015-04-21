def errorLogging(e)
	p "ERROR: #{e}"
	puts e.backtrace

	errorLog = '../ERRORS.txt'

	if(File.exist?(errorLog)===false)
		File.open(errorLog,'w')
	end

	File.open(errorLog,'a'){|f|
		[
			'====================',
			Time.now,
			e,
			e.backtrace
		].each{|err| 
			f.puts(err)
		}
	}
end

def openPage(url)
	retryCount = 0
	
	begin
		p "OPENING #{url}."
		page = Nokogiri::HTML(open(url))
	rescue Exception => e
		if(retryCount<10)
			p "ERROR OPENING #{e}",
			"RETRYING IN FIVE SECONDS"
			sleep 5
			retryCount+=1
			retry
		else
			p "ERROR OPENING #{e} AFTER TEN TRIES. MOVING ON."
			return false
		end	
	end
end

def artistId(artist)
	return Artist.artistId(artist)
end

def songIds(artistName,songName)
	return Track.songIds(artistName,songName)
end

def saveTrack(songIdArray,lyrics)
	if(lyrics!="")
		songIdArray.each{|songId|
			trackInfo = Track[:row=>songId]
			trackInfo.lyrics = lyrics
			begin
				trackInfo.save_changes
				p trackInfo
			rescue Exception => e
				p "ERROR SAVING TRACK: #{e}",
				"RETRYING IN FIVE SECONDS"
				sleep 5
				retry
			end
		}
	end
end