const express = require('express');

const helloRoute = require('./routes/hello')

const PORT = 3000;

const app = express();
 
app.use(helloRoute); 


app.listen(PORT,"0.0.0.0", function(){
    console.log(`Server is running ${PORT}`)
})