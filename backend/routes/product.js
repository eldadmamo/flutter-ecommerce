const express = require("express");
const Product = require('../models/product');
const {auth,vendorAuth} = require('../middleware/auth');

const productRouter = express.Router();

productRouter.post('/api/add-product',auth,vendorAuth, async (req, res) => {
    try{
        const {productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images} = req.body;

        const product = new Product({productName, productPrice, quantity, description, category, vendorId,fullName, subCategory, images});
        await product.save();
        res.status(200).send(product);
    }catch(e){
        res.status(400).json({error: e.message});
    }
})


productRouter.get('/api/popular-products', async (req, res) => {
    try{
       const product = await Product.find({popular: true});
        if(!product && product.length == 0){
            return res.status(404).json({msg:"products not found"})
        } else {
            return res.status(200).json({product});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})

productRouter.get('/api/recommended-products', async (req, res) => {
    try{
       const product = await Product.find({recommend: true});
        if(!product && product.length == 0){
            return res.status(404).json({msg:"products not found"})
        } else {
            return res.status(200).json({product});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})

// new router for retriving products by category 
productRouter.get('/api/products-by-category/:category', async(req, res) => {
    try{
        const {category} = req.params;
        const products = await Product.find({category, popular: true});
        if(!products || products.length==0){
            return res.status(404).json({msg: "Product not found"})
        } else {
            return res.status(200).json(products)
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})


productRouter.get('/api/related-products-by-subcategory/:productId', async (req,res)=> {
    try{
    const {productId} = req.params;
    const product = await Product.findById(productId);
    if(!product){
        return res.status(404).json({msg: "Product not found"})
    } else {
       const relatedProducts =  await Product.find({
            subCategory: product.subCategory, 
            _id: {$ne:productId} //exclude the current product
        });

        if(!relatedProducts || relatedProducts.length == 0){
            return res.status(404).json({msg: "No related products found"})
        }
        return res.status(200).json(relatedProducts);

    }
    }catch(e){
        return res.status(500).json({error:e.message});
    }
})

productRouter.get('/api/top-rated-products', async (req,res) => {
    try{

        const topRatedProducts = await Product.find({}).sort({averageRating: -1}).limit(10) //sort product by averageRating, with indicating decending

        if(!topRatedProducts || topRatedProducts.length == 0){
            return res.status(404).json({msg: "No top-rated products found"})
        }
        //return the top-rated product as a response 
        return res.status(200).json(topRatedProducts);
 
    }catch(e){
        return res.status(500).json({error:e.message})
    }
})


module.exports = productRouter;