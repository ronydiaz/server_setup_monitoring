#!/usr/bin/env python3

import json

with open('pods.json','r') as file:
    data = json.load(file)

#print(data)


all_cpu=[]
all_ram=[]

for pods in data:
    for containers in pods["spec"]["containers"]:
        #print(containers)
        cpu_str = containers["resources"]["requests"]["cpu"]
        ram_str = containers["resources"]["requests"]["memory"]

        cpu_int = int(cpu_str[:-1])
        ram_int = int(ram_str[:-2])

        all_cpu.append(cpu_int)
        all_ram.append(ram_int)

print(f"Total CPU usage: {sum(all_cpu)}")
print(f"Total RAM usage: {sum(all_ram)}")
print(f"Average CPU usage: {sum(all_cpu)/len(all_cpu):0.2f}")
print(f"Average RAM usage: {sum(all_ram)/len(all_ram):0.2f}")
