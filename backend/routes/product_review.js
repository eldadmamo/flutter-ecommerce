const express = require('express');
const ProductReview = require('../models/product_review');
const Product = require('../models/product');

const productReviewRouter = express.Router();

productReviewRouter.post('/api/product-review', async (req, res) => {
    try{
        const {buyerId, email, fullName, productId, rating, review} = req.body;
        
        const existingReview = await ProductReview.findOne({buyerId, productId});
        if(existingReview){
            return res.status(400).json({msg: "Your have already review this product"})
        } 
        const reviews = new ProductReview({buyerId, email, fullName, productId, rating, review});
        await reviews.save();


        //
        const product = await Product.findById(productId);
        if(!product){
            return res.status(404).json({msg: "product not found"})
        }

        //Update the total ratings by incrementing it by 1
        product.totalRatings +=1;

        product.averageRating = ((product.averageRating * (product.totalRatings-1))+ rating)/product.totalRatings;

        await product.save();

        return res.status(201).send(reviews);
    }catch(e){
        res.status(400).json({error: e.message});
    }
})

productReviewRouter.get('/api/reviews', async (req, res) => {
    try{
        const reviews = await ProductReview.find();
        return res.status(200).send({reviews});
    }catch(e){
        res.status(400).json({error: e.message});
    }
})


module.exports = productReviewRouter;