#!/usr/bin/env python3

import psutil
import time
import os
from pathlib import Path
from datetime import datetime
from playsound import playsound

def basedir():
    base = os.path.dirname(os.path.abspath(__file__))
    Path( base + '/logs' ).mkdir(parents=True, exist_ok=True)
    return base + '/'

def sess_data(data):
    fullpath = basedir() + "/logs/.diff_battery.txt"
    mf = Path(fullpath)
    mf.touch(exist_ok=True)

    f = open( fullpath, "r" )
    data_file = f.read()
    data_file = 0 if data_file == "" else int(data_file)
    f.close()

    f = open( fullpath, "w" )
    f.write(str(data))
    f.close()

    return int(data) != int(data_file)

def write_file(text):
    fullpath = basedir() + "/logs/.log_battery.txt"
    mf = Path(fullpath)
    mf.touch(exist_ok=True)

    f = open(fullpath, "a")
    f.write(str(text)+"\n")
    print(text)
    return f.close()

while True:
    time.sleep(5)
    battery = psutil.sensors_battery()
    plugged = battery.power_plugged
    percent = str(battery.percent)
    date_str = datetime.today().strftime('%Y-%m-%d %H:%M:%S :: ')

    if sess_data(percent):
        plugged_text = "Plugged In" if plugged else "Not Plugged In"
        write_file(date_str + percent + '% | ' + plugged_text)

        if int(percent) > 90 and plugged :
            playsound(basedir() + "full.m4a")
            # os.system("say battery is full")
            write_file(date_str + "battery is full")

        if int(percent) < 20 and plugged == False :
            playsound(basedir() + "low.m4a")
            # os.system("say battery is low")
            write_file(date_str + "battery is low")
