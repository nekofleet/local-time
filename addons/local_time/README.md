# <img src="icon.png" width="32" alt="addon icon"> LocalTime for Godot Engine 4
A class for local time.  
*Not compatible with DST.*

## How to install

### (1) Download ZIP file
\[ Code \](green button) &gt; Download ZIP  
*(If you want all files, please use git clone)*

### (2) Copy file
Copy from (unzipped file)/addons/local_time/local_time.gd  
to (your project)/(anywhere)/

## How to use
```
# Create object
var t = LocalTime.now()
# Setter / Getter
t.day = 15
print(t.month)
# Add time
t.add_days(100)
t.hour += 48
# Format
print(t.format("{lweekday}, {month}/{day}/{year}"))
```
See also class documents.  
Script tab &gt; Search Help &gt; LocalTime

## Versions
- 1.0.0: First version.
