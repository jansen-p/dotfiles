import pickle
import re
import os
from collections.abc import Callable
from prettytable import PrettyTable

class Tracker:
    def __init__(self, loc, loc_name, depth, init=False):
        self.current_location = loc
        self.loc_name = loc_name
        self.depth = depth

        self.src_path = os.getenv("FUZZY")

        if init:
            self.data = self.init()
        else:
            try:
                self.data = self.load()
            except:
                if not os.path.isfile(self.src_path+'.navi_hist/'+loc_name):
                    print("Didn't find history for this dir!\nInitialize one with 'init'.")
                    exit()

    #returns a list of shortened subdirectories, given a list of subdirectories (full paths)
    def get_shortened_dirs(self, dirs): #example: /run/Parts/Exch/Sync/uni/Studium/6.Sem/Grundlagen_ML/exercises -> Grundlagen_ML/exercises
        paths_short = []
        for f in dirs:
            dr = f[f.find(self.loc_name):]
            paths_short.append(dr[dr.find('/')+1:])
        return paths_short
    
    #returns a list of full-path-subdirectories, given a root-directory
    def get_subdirs(self, shortened=True, silent=False):
        paths = []
        exclude = ['data','components'] #don't include those dirs
        root_count = self.current_location.count('/')
        if not silent:
            print(root_count)
        for root, dirs, files in os.walk(self.current_location):
            #don't include dotfiles and names in "exclude"
            dirs[:] = [d for d in dirs if d not in exclude and d[0] != '.']
            for d in dirs:
                p = root+'/'+d
                if p.count('/') - root_count < self.depth + 1:
                    if not silent:
                        print(p)
                    paths.append(p)
        if shortened:
            return self.get_shortened_dirs(paths)
        else:
            return paths
    
    #save dictionary 
    def save(self):
        with open(self.src_path+'.navi_hist/'+self.loc_name, 'wb') as fp:
            pickle.dump(self.data, fp, protocol=pickle.HIGHEST_PROTOCOL)
    
    #returns the saved dictionary
    def load(self):
        with open(self.src_path+'.navi_hist/'+self.loc_name, 'rb') as fp:
            data = pickle.load(fp)
        return data
    
    #removes the specified dictionary
    def remove_dict(self):
        pass
    
    #sort dictionary depending on score values, descending order
    def sort_dict(self, item=1, order=True):
        return sorted(self.data.items(), key=lambda kv: kv[item], reverse=order)
    
    #returns an initialized dictionary of the given root directory
    def init(self):
        dic = dict((path, 0) for path in self.get_subdirs(self.current_location))
        print(bcolors.OKBLUE+"Subdirectories found:\n"+bcolors.ENDC)
        for i in dic:
            print("  - "+i) #need " " otherwise bash won't find whitespace (and won't print it)
        return dic
    
    #updates a given score entry (number of this entry in the sorted dictionary)
    def set_dict_score(self, num, score):
    
        if num == '.':
            k = os.getcwd()[len(self.current_location)+1:]
            if len(k) == 0:
                print("Failed to alter score")
                return
            print("entry "+bcolors.OKGREEN+str(k)+bcolors.ENDC+": assigned score",score)
            self.data[k] = score
        else:
            num = int(num)
            for key,index in zip(self.sort_dict(),range(len(self.data))):
                if index == num:
                    print("entry "+bcolors.OKGREEN+str(key[0])+bcolors.ENDC+": assigned score",score)
                    self.data[key[0]] = score;
    
        self.save();
    
    
    #returns an updated dict, removes old entries, adds untracked subdirectories from the dictionary
    def update(self, silent=False):
        subdirs = self.get_subdirs(silent=True)
    
        num_added = 0
        num_removed = 0
    
        remove = []
        
        if not silent:
            print(bcolors.FAIL)
    
        for d in self.data:
            if d in subdirs: #match, remove from subdirs
                subdirs.remove(d)
            else: #tracked dir, which doesn't exist anymore
                if not silent:
                    print(" - "+d)
                remove.append(d)
    
        for d in remove:
            num_removed = num_removed + 1
            self.data.pop(d)
    
        if not silent:
            print(bcolors.OKGREEN)
    
        for d in subdirs:
            num_added = num_added + 1
            if not silent:
                print(" + "+d)
            self.data[d] = 0 #add to dict
    
        if not silent:
            print(bcolors.ENDC+"\nDone.\n"+bcolors.FAIL+"Total number of entries removed: ",num_removed,bcolors.OKGREEN+"\nSubdirs added:",num_added,bcolors.ENDC)
    
    #given a 'search string', traverses the sorted dictionary and checks if there are matching entries
    #prints the full path of the first match
    #uses case-insensitive string comparison
    def find_hit(self, inp, match: Callable, response=False):
        sorted_tuples = self.sort_dict()
        hit = False
        first_run = True
        for row in sorted_tuples:
            #return match with highest score
            slash_occurrency = [m.start() for m in re.finditer('/',row[0].lower())]
    
            if len(slash_occurrency) > 2: # if more than 2 '/' found, cut entries
                start = slash_occurrency[-2] + 1
            else:
                start = 0 #don't cut entries
    
            #if inp.lower() in row[0].lower(): #case-insensitive comparison
            if match(row[0].lower()[start:], inp.lower()): #variant: just look at deepest two subdirs for inp
                hit=True
                val = row[0]
                self.data[val] = self.data[val] + 1;
                self.save()
                print(self.current_location+'/'+val)
                return hit;
    
        if not hit:
            if response:
                print(bcolors.FAIL+"No match for search string '"+inp+"'"+bcolors.ENDC+"\n")
                #print(bcolors.OKBLUE+"Rescanning...\n"+bcolors.ENDC)
        return hit;
    
    def rescale(self, minimum=0,maximum=20):
        vals = (lambda x: [int(((k-min(x))*maximum)/(max(x)-min(x))+minimum) for k in x])(self.data.values())
        for key, x in zip(self.data, vals):
            self.data[key] = x

    def print(self, num):
        t = PrettyTable(['#', 'Score', 'Path'])
        t.align["Score"] = "r"
        t.align["Path"] = "l"
        for x,index in zip(self.sort_dict()[:num],range(num if num != None else len(self.data))):
            t.add_row([str(index),x[1],x[0]])
        print(t)


class Matcher:
    @staticmethod
    def fuzzy(sentence, f):
        if len(f) == 0:
            return True

        idx = sentence.find(f[0])
        if idx == -1:
            return False
        else:
            return Matcher.fuzzy(sentence[idx+1:], f[1:])

    @staticmethod
    def stupid(sentence, f):
        return f in sentence   


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
