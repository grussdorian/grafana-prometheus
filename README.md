### Overall idea

Three different services collect statistics about the host machine, the docker containers, and kernel (host) metrics.
Prometheus, a time-series database collects (scraps) the metrics from the aforementioned services.
Grafana, a visualization web-service, will continuously present the data.

### Technical setup

A start script handles preliminary steps and calls docker-compose.
The start script builds local files and create docker images.
Docker-Compose starts all five services.

#### Requirements for local testing:

- libelf-dev
- clang
- docker.io
- docker-compose
- make
- stress

#### Task list

- In a seperate, temporary folder, clone & compile the ebpf_exporter without using docker.
- Run the syscalls example as described in the readme of ebpf_exporter
- Execute `stress -d 6 --hdd-bytes 10GB` and check if the amout of write syscalls increase substantially.
- The examples need be compiled locally and later mounted into the ebpf-container

- More info at [website](https://github.com/google/cadvisor)
- More info at [website](https://github.com/prometheus/node_exporter)

- Use `docker ps` to check

- Ensure that Prometheus is fetching metrics from all three sources (ebpf-exporter, cAdvisor, node-exporter)
  - Status -> Targets


- Create an empty dashboard in Grafana
- Create multiple panels in your dashboard using (but not limited to) these metrics:
  - `ebpf_exporter_syscalls_total`: Show the rate of all read and write syscalls (host).
  - `container_cpu_usage_seconds_total`: Show the CPU utilization of only the Prometheus container and only the Grafana container.
  - `ebpf_exporter_llc_misses_total`: Show the current rate of cache misses on the host.
  - `container_network_receive_bytes_total`, `container_network_transmit_bytes_total`: Show the network traffic of only the Prometheus container.
  - `node_memory_MemTotal_bytes`, `node_memory_MemAvailable_bytes`: Show the node's (host's) memory utilization.
  - `node_cpu_seconds_total`: Show the node's CPU utilization.
  - `ebpf_exporter_bio_latency_seconds_bucket`: show a historgram of your disk's write latency.
  - Also Create a panel that shows the memory utilization of the Grafana container after you added the other panels.

- Stress your machine with, e.g., `stress`, `dd`, or youtube, to see if your metrics change.
