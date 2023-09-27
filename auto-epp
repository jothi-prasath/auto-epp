#!/bin/python3

import os
import time
import sys
import configparser

CONFIG_FILE = "/etc/auto-epp.conf"
DEFAULT_CONFIG = """# see available epp state by running: cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
[Settings]
epp_state_for_AC=balance_performance
epp_state_for_BAT=power
"""

def check_root():
    if os.geteuid() == 0:
        return
    else:                                        
        print("auto-epp must be run with root privileges.")
        sys.stdout.flush()
        exit(1)

def check_driver():
    scaling_driver_path = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver"
    try:
        with open(scaling_driver_path) as f:
            scaling_driver = f.read()[:-1]
    except:
        scaling_driver = None
    if scaling_driver == "amd-pstate-epp":
        return
    else:
        print("The system not runing amd-pstate-epp")
        sys.stdout.flush()
        exit(1)

def read_config():
    if not os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'w') as file:
            file.write(DEFAULT_CONFIG)
    config = configparser.ConfigParser()
    config.read(CONFIG_FILE)
    epp_state_for_AC = config.get("Settings", "epp_state_for_AC")
    epp_state_for_BAT = config.get("Settings", "epp_state_for_BAT")
    return epp_state_for_AC, epp_state_for_BAT

def charging():
    power_supply_path = "/sys/class/power_supply/"
    power_supplies = os.listdir(power_supply_path)
    # sort it so AC is 'always' first
    power_supplies = sorted(power_supplies)
    if len(power_supplies) == 0:
        return True
    else:
        for supply in power_supplies:
            try:
                with open(power_supply_path + supply + "/type") as f:
                    supply_type = f.read()[:-1]
                    if supply_type == "Mains":
                        # we found an AC
                        try:
                            with open(power_supply_path + supply + "/online") as f:
                                val = int(f.read()[:-1])
                                if val == 1:
                                    # we are definitely charging
                                    return True
                        except FileNotFoundError:
                            # we could not find online, check next item
                            continue
                    elif supply_type == "Battery":
                        # we found a battery, check if its being discharged
                        try:
                            with open(power_supply_path + supply + "/status") as f:
                                val = str(f.read()[:-1])
                                if val == "Discharging":
                                    # we found a discharging battery
                                    return False
                        except FileNotFoundError:
                            # could not find status, check the next item
                            continue
                    else:
                        # continue to next item because current is not
                        # "Mains" or "Battery"
                        continue
            except FileNotFoundError:
                # could not find type, check the next item
                continue
    # we cannot determine discharging state, assume we are on powercable
    return True

def set_governor():
    get_governor_file_path = '/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'
    try:
        # get current governor
        with open(get_governor_file_path) as gov_file:
            cur_governor = gov_file.read()[:-1]
            if cur_governor != "powersave":
                print(f'Current governor "{cur_governor}" is not "powersave". Setting governor to "powersave"')
                sys.stdout.flush()

                # setting governor to powersave
                cpu_count = os.cpu_count()
                for cpu in range(cpu_count):
                    governor_file_path = f'/sys/devices/system/cpu/cpu{cpu}/cpufreq/scaling_governor'
                    with open(governor_file_path, 'w') as file:
                        file.write("powersave")
    except:
        exit(1)

def set_epp(epp_value):
    cpu_count = os.cpu_count()
    for cpu in range(cpu_count):
        epp_file_path = f'/sys/devices/system/cpu/cpu{cpu}/cpufreq/energy_performance_preference'
        try:
            with open(epp_file_path, 'w') as file:
                file.write(epp_value)
        except:
            exit(1)
            
def main():
    check_root()
    check_driver()
    epp_state_for_AC, epp_state_for_BAT = read_config()
    while True:
        set_governor()
        if charging():
            set_epp(epp_state_for_AC)
        else:
            set_epp(epp_state_for_BAT)
        time.sleep(2)

if __name__ == "__main__":
    main()
