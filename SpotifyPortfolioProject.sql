Select *
From SpotifyPortfolioProject..Features

Select *
From SpotifyPortfolioProject..Streams

-- Lets see what songs have the most streams

Select Song, Sum(StreamsBillions) as StreamsBiill
From SpotifyPortfolioProject..Streams
Group by Song
Order by 2 desc

-- Lets only see the top 10

Select Top(10)Song, Sum(StreamsBillions) as StreamsBiill
From SpotifyPortfolioProject..Streams
Group by Song
Order by 2 desc

-- Lets find the duration of the top songs vs how many streams

Select st.song, st.StreamsBillions, ft.duration
From SpotifyPortfolioProject..Streams as st
Join SpotifyPortfolioProject..Features as ft
	on st.Song = ft.name
Order by 2 desc

-- Lets see who has the most amount of hits
-- I had to use a CHARINDEX function since many of the main artists also had songs that had 
-- collaborations so I needed to get rid of the featuring artist

Select LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1) as Artist, count(Artist) as ArtistHits
From SpotifyPortfolioProject..Streams
Group by LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1)
Order by 2 Desc

-- Top 10?

Select Top(10)LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1) as Artist, count(Artist) as ArtistHits
From SpotifyPortfolioProject..Streams
Group by LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1)
Order by 2 Desc

-- What was every artists avg song length

Select LEFT(st.Artist, CHARINDEX('Â', st.Artist + 'Â') - 1) as Artist, AVG(ft.duration) as AvgSongLength
From SpotifyPortfolioProject..Streams as st
Join SpotifyPortfolioProject..Features as ft
	on st.Song = ft.name
Group by LEFT(st.Artist, CHARINDEX('Â', st.Artist + 'Â') - 1)
Order by 2 Desc

-- Lets also add what their average song length was and total number of streams

Select LEFT(st.Artist, CHARINDEX('Â', st.Artist + 'Â') - 1) as Artist, count(st.Artist) as ArtistHits, Sum(st.StreamsBillions) as StreamsBillions, AVG(ft.duration) as AvgSongLength
From SpotifyPortfolioProject..Streams as st
Join SpotifyPortfolioProject..Features as ft
	on st.Song = ft.name
Group by LEFT(st.Artist, CHARINDEX('Â', st.Artist + 'Â') - 1)
Order by 2 Desc

-- What percentage of total top 100 streams did each artist take up.
-- In order to find total streams, I had to implement a subquery.

Select LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1) as Artist, Sum(StreamsBillions) as StreamsBill, (Select SUM(StreamsBillions) From SpotifyPortfolioProject..Streams) as TotalStreams,
(Sum(StreamsBillions)/(Select SUM(StreamsBillions) From SpotifyPortfolioProject..Streams))*100 as PercentofTotalStreams
From SpotifyPortfolioProject..Streams
Group by LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1)
Order by 2 Desc

-- Avgerage of all sound types

Select AVG(duration) as duration, AVG(energy) as energy, AVG([key]) as [key], AVG(loudness) as loudness, AVG(speechiness) as speechiness, 
AVG(acousticness) as acousticness, AVG(liveness) as liveness, AVG(valence) as valence, AVG(tempo) as tempo, AVG(danceability) as danceability
From SpotifyPortfolioProject..Features

-- Lets see if there is a trend between dancability and number of streams

Select ft.Name, AVG(ft.danceability) as Danceability,(Select AVG(danceability) from SpotifyPortfolioProject..Features) As AvgDanceability, 
Sum(st.StreamsBillions) as StreamsBill
From SpotifyPortfolioProject..Features as ft
Join SpotifyPortfolioProject..Streams as st
	on ft.name = st.Song
Group by ft.Name
Order by 3 Desc

-- Lets see if there is a correlation between key and streams

Select ft.Name, AVG(ft.[key]) as Songkey, 
Sum(st.StreamsBillions) as StreamsBill
From SpotifyPortfolioProject..Features as ft
Join SpotifyPortfolioProject..Streams as st
	on ft.name = st.Song
Group by ft.Name
Order by 3 Desc

Create View Top10Songs as
Select Top(10)Song, Sum(StreamsBillions) as StreamsBiill
From SpotifyPortfolioProject..Streams
Group by Song
Order by 2 desc

Create View MetricAvg as
Select AVG(duration) as duration, AVG(energy) as energy, AVG([key]) as [key], AVG(loudness) as loudness, AVG(speechiness) as speechiness, 
AVG(acousticness) as acousticness, AVG(liveness) as liveness, AVG(valence) as valence, AVG(tempo) as tempo, AVG(danceability) as danceability
From SpotifyPortfolioProject..Features

Create View PercentTotalStreams as
Select LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1) as Artist, Sum(StreamsBillions) as StreamsBill, (Select SUM(StreamsBillions) From SpotifyPortfolioProject..Streams) as TotalStreams,
(Sum(StreamsBillions)/(Select SUM(StreamsBillions) From SpotifyPortfolioProject..Streams))*100 as PercentofTotalStreams
From SpotifyPortfolioProject..Streams
Group by LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1)
--Order by 2 Desc

Create View Top10Artists as
Select Top(10)LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1) as Artist, count(Artist) as ArtistHits
From SpotifyPortfolioProject..Streams
Group by LEFT(Artist, CHARINDEX('Â', Artist + 'Â') - 1)
--Order by 2 Desc

Create View StreamsvsDuration as
Select st.song, st.StreamsBillions, ft.duration
From SpotifyPortfolioProject..Streams as st
Join SpotifyPortfolioProject..Features as ft
	on st.Song = ft.name
--Order by 2 desc

Create View KeyvsStreams as
Select ft.Name, AVG(ft.[key]) as Songkey, 
Sum(st.StreamsBillions) as StreamsBill
From SpotifyPortfolioProject..Features as ft
Join SpotifyPortfolioProject..Streams as st
	on ft.name = st.Song
Group by ft.Name
--Order by 3 Desc