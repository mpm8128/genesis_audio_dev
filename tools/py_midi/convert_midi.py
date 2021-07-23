#!/usr/bin/python3

import MIDI

midi_file = MIDI.MIDIFile("./test_midi.mid")
#midi_file = MIDI.MIDIFile("./agr14.mid")

midi_file.parse()

#print("Format: "+ str(midi_file.format))
#print("Division: " + str(midi_file.division))

frame_time = (1/60)

#get iterator
tracks = iter(midi_file)
tempo_found = False
time_error = 0
prev_frames = 0
prev_event = None

for track in tracks:
    track.parse()
    events = iter(track)
    for event in events:
        #print(event)
        #print(event.buffer.hex())
        #print(hex(event.header))
        if tempo_found == False:
            if str(event.message).__contains__("Tempo"):
                us_per_qn = int.from_bytes(event.data, "big")
                #print(us_per_qn)
                ticks_per_qn = midi_file.division
                #print(ticks_per_qn)
                us_per_tick = us_per_qn / ticks_per_qn
                #print(us_per_tick)
                secs_per_tick = us_per_tick / 1000000
                #print(secs_per_tick)
                ticks_per_sec = 1 / secs_per_tick
                #print(ticks_per_sec)#print(ticks_per_sec)
                ticks_per_frame = ticks_per_sec / 60
                print("Ticks Per Frame: " + str(ticks_per_frame))
                tempo_found = True
                break
        else:
            #print(event.message)
            abs_frames = event.time / ticks_per_frame
            
            disc_abs_frames = int(abs_frames)
            error = abs_frames - disc_abs_frames

            #print(abs_frames)
            #print(disc_abs_frames)
            #print(error)

            rel_frames = disc_abs_frames - prev_frames
            prev_frames = disc_abs_frames
            #print(event.__dict__)
            if (prev_event is not None) and (rel_frames > 0):
                #print(prev_event)
                if "command" in prev_event.__dict__:
                    #note ON
                    if prev_event.command == 144:
                        note_name = str("note_" + str(prev_event.message.note)[0:-1]).replace("#","s")
                        print("M_play_note " + note_name + ", " + str(prev_event.message.note)[-1] + ", " + str(rel_frames))
                    #note OFF
                    elif prev_event.command == 128:
                        print("M_play_rest " + str(rel_frames))
        prev_event = event   
                
            
    

exit()
