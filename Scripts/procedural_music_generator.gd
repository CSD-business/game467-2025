extends Node

var prevDrums
var prevSynth
var prevBlip
var curDrums = 1
var curSynth = 1
var curBlip = 1

var drumReps = 0
var synthReps = 0
var blipReps = 0
var goalDrumReps = 3
var goalSynthReps = 1
var goalBlipReps = 3

func generate_procedural_music():
	#new_blip_reps()
	#new_drum_reps()
	#new_synth_reps()
	play_drums()
	play_blip()
	$SynthTimer.start()
	await get_tree().create_timer(2).timeout
	play_drums()
	play_blip()
	$DrumTimer.start()
	$BlipTimer.start()

func play_drums():
	if (curDrums == 1):
		$Drums/Drums1.play()
	if (curDrums == 2):
		$Drums/Drums2.play()
	if (curDrums == 3):
		$Drums/Drums3.play()
	if (curDrums == 4):
		$Drums/Drums4.play()

func play_synth():
	if (curSynth == 1):
		$Synth/Synth1.play()
	if (curSynth == 2):
		$Synth/Synth2.play()
	if (curSynth == 3):
		$Synth/Synth3.play()

func play_blip():
	if (curBlip == 1):
		$Blip/Blip1.play()
	if (curBlip == 2):
		$Blip/Blip2.play()
	if (curBlip == 3):
		$Blip/Blip3.play()

func new_drums():
	prevDrums = curDrums
	while (curDrums == prevDrums):
		curDrums = randi_range(1, 4)
	return curDrums

func new_synth():
	prevSynth = curSynth
	while (curSynth == prevSynth):
		curSynth = randi_range(1, 3)
	return curSynth

func new_blip():
	prevBlip = curBlip
	while (curBlip == prevBlip):
		curBlip = randi_range(1, 3)
	return curBlip

func new_drum_reps():
	var dreps = randi_range(1, 3)
	if dreps == 1:
		goalDrumReps = 1
	if dreps == 2:
		goalDrumReps = 3
	if dreps == 3:
		goalDrumReps = 7

func new_synth_reps():
	var sreps = randi_range(1, 2)
	if sreps == 1:
		goalSynthReps = 1
	if sreps == 2:
		goalSynthReps = 3

func new_blip_reps():
	var breps = randi_range(1, 3)
	if breps == 1:
		goalBlipReps = 1
	if breps == 2:
		goalBlipReps = 3
	if breps == 3:
		goalBlipReps = 7

func _on_drum_timer_timeout() -> void:
	play_drums()
	if drumReps == goalDrumReps:
		curDrums = new_drums()
		#new_drum_reps()
		drumReps = 0
	else:
		drumReps += 1

func _on_blip_timer_timeout() -> void:
	play_blip()
	if blipReps == goalSynthReps:
		curBlip = new_blip()
		#new_blip_reps()
		blipReps = 0
	else:
		blipReps += 1

func _on_synth_timer_timeout() -> void:
	play_synth()
	if synthReps == goalSynthReps:
		curSynth = new_synth()
		#new_synth_reps()
		synthReps = 0
	else:
		synthReps += 1
