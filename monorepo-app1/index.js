const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('app1 ver 0.0.2 executed'));

app.listen(3000, () => console.log('app1 listening on port 3000!'));