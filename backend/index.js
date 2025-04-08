require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bannerRouter = require('./routes/banner')
const authRouter = require('./routes/auth')
const cateogryRouter = require('./routes/category')
const subcategoryRouter = require('./routes/sub_category')
const productRouter = require('./routes/product')
const productReviewRouter =require('./routes/product_review')
const vendorRouter = require('./routes/vendor')
const orderRouter = require('./routes/order')
const PORT = 3000;


const app = express();
app.use(cors({ origin: '*', credentials: true }));
app.use(express.json());
app.use(authRouter);
app.use(bannerRouter);
app.use(cateogryRouter);
app.use(subcategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(vendorRouter);
app.use(orderRouter);
 
const DB = "mongodb://127.0.0.1:27017/flutter"


mongoose.connect(DB).then(() => { 
    console.log('Mongodb Connected')
})


app.listen(PORT,"0.0.0.0", function(){
    console.log(`Server is running ${PORT}`)
})