#!/usr/bin/python3

import MIDI
import sys

if len(sys.argv) <= 1:
    print("usage:")
    print("./convert_midi.py <midi file>")
    exit()
    
if len(sys.argv) == 3:
    transpose = sys.argv[2]

midi_file = MIDI.MIDIFile(sys.argv[1])
midi_file.parse()

frame_time = (1/60)

#get iterator
tracks = iter(midi_file)

#initialize stuff
tempo_found = False
time_error = 0
prev_frames = 0
prev_event = None

for track in tracks:
    track.parse()
    events = iter(track)

    for event in events:
        print(event)

exit()
