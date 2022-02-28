#!/usr/bin/env python
import sys
from datetime import datetime as date
import datetime
import array as arr

def num(s):
    try:
        return int(s)
    except ValueError:
        return ' '

if __name__ == "__main__":
    day = date.today().strftime("%A")[0:2] #first 2 characters of current day

    nextDays = dict() #if today is monday, then nextDays['We']=2

    for i in range(1,8):  #zahlen von 1 bis 6
        nextDays[(date.today() + datetime.timedelta(days=i)).strftime("%A")[0:2]] = i

    notes = []
    notesDate = []
    notesCan = []
    notesRest = []
    for line in sys.stdin.readlines(): #piped input
        line = line.strip() #remove line breaks

        if line[-2:] in nextDays: #if day found at end of line, insert number
            notes.append(str(nextDays[line[-2:]]) + '. ' + line)
        elif line[-2:] == 'sc':
            notesCan.append('-> ' +line)
        elif (num(line[-5:-3]) in range(1,32) and num(line[-2:]) in range(1,13)): #valid date at the end?
            notesDate.append('-> '+line) #append line to correct list
        else:
            notesRest.append('-> '+line)

    notes.sort() # sort depending on number of days left
    notes.append('===========================================================')
    notesDate.sort(key=lambda x: date.strptime(x[-5:], '%d.%m')) #sort depending on date
    notesDate.append('===========================================================\n Skripts')
    notesCan.sort()
    notesCan.append('===========================================================')
    notesRest.sort() # sort alphabetically

    notes = notes + notesDate + notesCan + notesRest

    for line in notes:
        print(line)
