const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const authRouter = require('./routes/auth')

const PORT = 3000;

const app = express();
app.use(cors({ origin: '*', credentials: true }));
app.use(express.json());
app.use(authRouter);

const DB = "mongodb://127.0.0.1:27017/flutter"

mongoose.connect(DB).then(() => {
    console.log('Mongodb Connected')
})


app.listen(PORT,"0.0.0.0", function(){
    console.log(`Server is running ${PORT}`)
})