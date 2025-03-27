const express = require('express');

const helloRoute = express.Router();

helloRoute.get('/hellos',(req, res) => {
    res.send('Hello world');
});

module.exports = helloRoute;

