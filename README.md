# somewhere.js [![Build Status](https://travis-ci.org/dreyacosta/somewhere.js.svg?branch=master)](https://travis-ci.org/dreyacosta/somewhere.js)
### Small JSON file database

## Installation
```sh
$ npm install somewhere
```

## Usage

### Load
```js
var db = require('somewhere');
```

### Database connection
```js
db.connect('path/to/file.json');
```

### Save
```js
db.save('collection', data);
```

```js
var movie = {
  id: "1",
  title: "Die Hard",
  genre: "Action",
  director: "John McTiernan",
  description: "John McClane, officer of the NYPD, tries to save wife Holly
  Gennaro and several others, taken hostage by German terrorist Hans Gruber
  during a Christmas party at the Nakatomi Plaza in Los Angeles."
};

db.save('movies', movie);
```

### Find one
```js
db.findOne('collection', query);
```

```js
db.findOne('movies', { title: 'Die Hard' });

/** Result: Object
  {
    id: "1",
    title: "Die Hard",
    genre: "Action",
    director: "John McTiernan",
    description: "John McClane, officer of the NYPD, tries to save wife Holly
    Gennaro and several others, taken hostage by German terrorist Hans Gruber
    during a Christmas party at the Nakatomi Plaza in Los Angeles."
  }
*/
```

### Find all
```js
db.find('movies', { genre: 'Action' });
```

```js
db.find('movies', { genre: 'Die Hard' });

/** Result: Objects array
  [{
    id: "1",
    title: "Die Hard",
    genre: "Action",
    director: "John McTiernan",
    description: "John McClane, officer of the NYPD, tries to save wife Holly
    Gennaro and several others, taken hostage by German terrorist Hans Gruber
    during a Christmas party at the Nakatomi Plaza in Los Angeles."
  }]
*/
```

### Update
```js
db.update('movies', id, data);
```

```js
db.update('movies', 1, { genre: "Action/Thriller" });

/** Result: Updated Object
  {
    id: "1",
    title: "Die Hard",
    genre: "Action/Thriller",
    director: "John McTiernan",
    description: "John McClane, officer of the NYPD, tries to save wife Holly
    Gennaro and several others, taken hostage by German terrorist Hans Gruber
    during a Christmas party at the Nakatomi Plaza in Los Angeles."
  }
*/
```

### Remove
```js
db.remove('movies', id);
```

```js
db.remove('movies', 1);
```

## License
This software is free to use under the MIT license.