ASP.NET vNext application with a dev environment based on Docker

Running:

```
# Build the docker image and create a data container
make build

# Restore NuGet packages
make restore

# Run kestrel and serve the web app on http://localhost:5004
make run

# Ctrl-D will then stop the container
```
