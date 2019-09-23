# Usage

To build a Bookworm instance, you will need to place three files in `data`:

1. [`input.txt`](https://bookworm-project.github.io/Docs/input.txt.html): This file contains the text data that the BookwormDB will search and visualize. This file will contain one row for each of your input texts. Each of those rows should have the format:

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

2. [`jsoncatalog.txt`](https://bookworm-project.github.io/Docs/JSONcatalog.html): This file contains metadata for each input text. This file will contain one row for each of your input texts. Each of those rows should contain a JSON object with at least the following two fields:

`searchstring`: The searchstring will identify a document to users. The searchstring may contain plaintext, a url to HTML, or inlined HTMl that contains text describing a document.

`filename`: The filename for this given document. Document filenames must be globally unique within your input corpus.

Example `jsoncatalog.txt`:

```
{"publishers": ["Simon & Schuster Books for Young Readers"], "searchstring": "[No author], Ernestine & Amanda, summer camp ready or not! (undated) more info read", "lc2": "7", "lc0": "P", "title": "Ernestine & Amanda, summer camp ready or not!", "lccn": ["96041443"], "lc1": "PZ", "editionid": "/books/OL1002147M", "publish": 1997, "filename": "er/ne/ernestineamandas00belt", "languages": ["/languages/eng"], "lc_classifications": ["PZ7.B4197 Er 1997"], "publish_date": "1997", "publish_country": "nyu", "key": "/books/OL1002147M", "authors": ["/authors/OL24054A"], "ocaid": "ernestineamandas00belt", "oclc_numbers": ["35360730"], "works": ["/works/OL16070305W"], "publish_places": ["New York"]}
{"publishers": ["Copernicus"], "searchstring": "[No author], The call of distant mammoths (undated) more info read", "lc2": "882", "lc0": "Q", "title": "The call of distant mammoths", "lccn": ["96048690"], "lc1": "QE", "editionid": "/books/OL1008703M", "publish": 1997, "filename": "ca/ll/callofdistantmam00ward", "languages": ["/languages/eng"], "lc_classifications": ["QE882.P8 W37 1997"], "publish_date": "1997", "publish_country": "nyu", "key": "/books/OL1008703M", "authors": ["/authors/OL224736A"], "ocaid": "callofdistantmam00ward", "publish_places": ["New York"], "works": ["/works/OL1876772W"]}
{"publishers": ["Children's Press"], "searchstring": "[No author], Qatar (undated) more info read", "lc2": "247", "lc0": "D", "title": "Qatar", "lccn": ["96049593"], "lc1": "DS", "editionid": "/books/OL1009559M", "publish": 1997, "filename": "qa/ta/qataraugu00augu", "languages": ["/languages/eng"], "lc_classifications": ["DS247.Q3 A94 1997"], "publish_date": "1997", "publish_country": "nyu", "key": "/books/OL1009559M", "authors": ["/authors/OL544559A"], "ocaid": "qataraugu00augu", "oclc_numbers": ["36008545"], "works": ["/works/OL3353201W"], "publish_places": ["New York"]}
```

3.




```
# build a bookworm image
docker build --tag bookworm --file image-base/Dockerfile .

# find the id of the bookworm image you just made
docker images

# start a container (an instance of the bookworm image)
docker run \
  -v $(pwd)/data:/data \
  -dit bookworm

# find all bookworm containers (instances of the bookworm image)
docker ps -a

# drop a shell into the container (instance of image)
docker exec -it {{ CONTAINER_ID, e.g. c9989785d56c }} /bin/bash
```

from master
cd into mysql-data
bookworm init

that creates .bookworm (empty)
and bookworm.cnf, which is a clone of .my.cnf

then bookworm build all

