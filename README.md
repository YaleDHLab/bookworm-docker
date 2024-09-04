# Note: This repository has been archived
This project was developed under a previous phase of the Yale Digital Humanities Lab. Now a part of Yale Library’s Computational Methods and Data department, the Lab no longer includes this project in its scope of work. As such, it will receive no further updates.


# Bookworm Docker

Making it easier to visualize [BookwormDB](https://github.com/Bookworm-project/BookwormDB) instances.

## Quickstart

```
# download sample input data
wget https://lab-data-collections.s3.amazonaws.com/sample-bookworm-inputs.tar.gz && \
  tar -zxf sample-bookworm-inputs.tar.gz && \
  rm sample-bookworm-inputs.tar.gz && \
  mv sample-bookworm-inputs data

# build the base bookworm image
docker build --tag bookworm:latest --file Dockerfile .

# process the data within `./data` inside the container
bash build.sh
```

Then open a web browser to `http://localhost:8005/data/#`. The first time you load the webpage it will take some time for the visualization to display, as Bookworm will need to prime the MySQL cache.

Once you're done examining your visualization, stop the container:

```
docker ps -a | grep bookworm | awk '{print $1}' | xargs docker stop
```

## Preparing Custom Data

To build a new bookworm using this repository, you need to place three files in `./data`:

**1. [`input.txt`](https://bookworm-project.github.io/Docs/input.txt.html)**: This file contains the text data that the BookwormDB will search and visualize. This file will contain one row for each of your input texts. Each of those rows should have the format:

```
file-basename *tab* long string with entire text content
file-basename *tab* long string with entire text content
```

Example `input.txt`:

```
declaration\twhen in the course of human events\n
constitution\twe the people of the united states\n
gettysburgh\tfour score and seven years ago\n
```

**2. [`jsoncatalog.txt`](https://bookworm-project.github.io/Docs/JSONcatalog.html)**: This file contains metadata for each input text. This file will contain one row for each of your input texts. Each of those rows should contain a JSON object with at least the following two fields:

`searchstring`: The searchstring will identify a document to users. The searchstring may contain plaintext, a url to HTML, or inlined HTMl that contains text describing a document.

`filename`: The filename for this given document. Document filenames must be globally unique within your input corpus.

Example `jsoncatalog.txt`:

```json
{"searchstring": "Summer Camp Ready or Not!", "filename": "er/ne/ernestineamandas00belt", "subjects": ["summer"]}
{"searchstring": "The Call of Mammoths", "filename": "ca/ll/callofdistantmam00ward", "subjects": ["mammoths"]}
{"searchstring": "Qatar: More Info", "filename": "qa/ta/qataraugu00augu", "subjects": ["qatar", "info"]}
```

**3. [`field_descriptions.json`](https://bookworm-project.github.io/Docs/field_descriptions.json.html)**: This file outlines the data type and other attributes for each of the metadata fields in your corpus. This file will consist of a JSON array with one object for each of the metadata fields in your corpus. Example:

```json
[
  {
    "field": "searchstring",
    "datatype": "searchstring",
    "type": "text",
    "unique": true
  },
  {
    "field": "subjects",
    "datatype": "categorical",
    "type": "text",
    "unique": false
  }
]
```
Once you've prepared these three files, create a fresh clone of this repository, place those files in `./data`, and run the commands above to create your bookworm!

## Development

```
# find the ids of all bookworm images
docker images

# start the built image with data mounts and port forwarding
docker run -p 8005:8005 -v $(pwd)/data:/data -dit bookworm

# find all bookworm containers (instances of the bookworm image)
docker ps -a

# drop a shell into the container (instance of image)
docker exec -it {{ CONTAINER_ID, e.g. c9989785d56c }} /bin/bash
```
