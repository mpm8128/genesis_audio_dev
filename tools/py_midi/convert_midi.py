#!/usr/bin/python3

import MIDI
import sys

if len(sys.argv) <= 1:
    print("usage:")
    print("./convert_midi.py <midi file> [transpose octave]")
    exit()
    
transpose = 0
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
        #print(event)
        #we need to get initial tempo information, or we can't convert
        if tempo_found == False:
            if str(event.message).__contains__("Tempo"):
                us_per_qn = int.from_bytes(event.data, "big")
                ticks_per_qn = midi_file.division
                us_per_tick = us_per_qn / ticks_per_qn
                secs_per_tick = us_per_tick / 1000000
                ticks_per_sec = 1 / secs_per_tick
                ticks_per_frame = ticks_per_sec / 60
                #print("Ticks Per Frame: " + str(ticks_per_frame))
                tempo_found = True
                break
        #we have tempo information now
        else:
            #print(event.message)
            abs_frames = event.time / ticks_per_frame
            
            disc_abs_frames = int(abs_frames)
            error = abs_frames - disc_abs_frames
            
            rel_frames = disc_abs_frames - prev_frames
            prev_frames = disc_abs_frames
            #print(event.__dict__)
            if (prev_event is not None) and (rel_frames > 0):
                #print(prev_event)
                if "command" in prev_event.__dict__:
                    #note ON
                    if prev_event.command == 144:
                        note_name = str("note_" + str(prev_event.message.note)[0:-1]).replace("#","s")
                        print("    M_play_note " + note_name + ", " + str(int(str(prev_event.message.note)[-1]) + int(transpose)) + ", " + str(rel_frames))
                    #note OFF
                    elif prev_event.command == 128:
                        print("    M_play_rest " + str(rel_frames))

            prev_event = event

            #print(error)  
exit()
