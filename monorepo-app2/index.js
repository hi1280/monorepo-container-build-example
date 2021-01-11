const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('app2 ver 0.0.1 executed'));

app.listen(3000, () => console.log('app2 listening on port 3000!'));