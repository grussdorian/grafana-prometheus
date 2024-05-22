# As there wasn't any option to export the dashboard as yaml
# This python code converts the dashboard's json file to yaml

import json
import yaml

# Load the JSON file
with open('dashboard.json', 'r') as f:
    data = json.load(f)

# Convert the JSON to YAML
yaml_data = yaml.dump(data)

# Write the YAML data to a file
with open('dashboard.yml', 'w') as f:
    f.write(yaml_data)