extends Node

#var song: AudioStreamPlayer

func fade_in_music(song: AudioStreamPlayer):
	song.play()
	song.volume_db = -60
	while song.volume_db < -5:
		await get_tree().create_timer(0.1).timeout
		song.volume_db += 5.5

func fade_out_music(song: AudioStreamPlayer):
	while song.volume_db > -60:
		await get_tree().create_timer(0.1).timeout
		song.volume_db -= 5.5
	song.stop()

func generate_music():
	$"Procedural Music Generator".generate_procedural_music()
