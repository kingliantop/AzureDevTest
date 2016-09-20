A simple container that outputs simulated log information to stdout and stderr. It is used to simulate tests running within the container. Useful for generating log output for use in log processors.

# Build

docker build -t rgardler/simulated-tests .

# Running

docker run rgardler/simulated-tests 
